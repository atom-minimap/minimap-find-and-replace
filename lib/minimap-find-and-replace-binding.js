/** @babel */

const { CompositeDisposable } = require('atom')

class MinimapFindAndReplaceBinding {
	constructor (minimap, fnrAPI, fnrVisible) {
		this.minimap = minimap
		this.fnrAPI = fnrAPI
		this.fnrVisible = fnrVisible
		this.editor = this.minimap.getTextEditor()
		this.subscriptions = new CompositeDisposable()
		this.decorationsByMarkerId = new Map()
		this.subscriptionsByMarkerId = new Map()

		this.layer = this.fnrAPI.resultsMarkerLayerForTextEditor(this.editor)

		this.subscriptions.add(this.layer.onDidUpdate(() => {
			if (this.fnrVisible) {
				this.discoverMarkers()
			}
		}))

		this.discoverMarkers()
	}

	disposeMarkerSubsctiotions () {
		const markerSubscriptions = this.subscriptionsByMarkerId.values()
		for (const markerSubscription of markerSubscriptions) {
			markerSubscription.dispose()
		}
		const decorationSubscriotions = this.decorationsByMarkerId.values()
		for (const decorationSubscriotion of decorationSubscriotions) {
			decorationSubscriotion.destroy()
		}
	}

	destroy () {
		this.subscriptions.dispose()
		this.clear()
		this.minimap = null
		this.editor = null
	}

	changeVisible (visible) {
		this.fnrVisible = visible
		if (visible) {
			this.discoverMarkers()
		} else {
			this.clear()
		}
	}

	clear () {
		this.disposeMarkerSubsctiotions()
		this.decorationsByMarkerId.clear()
		this.subscriptionsByMarkerId.clear()
	}

	discoverMarkers () {
		setImmediate(() => {
			const markers = this.layer.getMarkers()
			for (const marker of markers) {
				this.createDecoration(marker)
			}
		})
	}

	createDecoration (marker) {
		if (!this.findViewIsVisible()) {
			return
		}
		if (this.decorationsByMarkerId.has(marker.id)) {
			return
		}

		const decoration = this.minimap.decorateMarker(marker, {
			type: 'highlight',
			scope: '.minimap .search-result',
			plugin: 'find-and-replace',
		})

		if (!decoration) {
			return
		}

		const { id } = marker
		this.decorationsByMarkerId.set(id, decoration)
		this.subscriptionsByMarkerId.set(id,
			decoration.onDidDestroy(() => {
				this.subscriptionsByMarkerId.get(id).dispose()
				this.subscriptionsByMarkerId.delete(id)
			}),
		)
	}

	findViewIsVisible () {
		return (document.querySelector('.find-and-replace') !== null)
	}
}

module.exports = MinimapFindAndReplaceBinding
