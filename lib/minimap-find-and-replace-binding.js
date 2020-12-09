/** @babel */

const { CompositeDisposable } = require('atom')

class MinimapFindAndReplaceBinding {
	constructor (minimap, fnrAPI, fnrVisible) {
		this.minimap = minimap
		this.fnrAPI = fnrAPI
		this.fnrVisible = fnrVisible
		this.editor = this.minimap.getTextEditor()
		this.subscriptions = new CompositeDisposable()
		this.decorationsByMarkerId = {}
		this.subscriptionsByMarkerId = {}

		this.layer = this.fnrAPI.resultsMarkerLayerForTextEditor(this.editor)

		this.subscriptions.add(this.layer.onDidUpdate(() => {
			if (this.fnrVisible) {
				this.discoverMarkers()
			}
		}))

		this.discoverMarkers()
	}

	destroy () {
		const subscriptionsByMarkerIdKeys = Object.keys(this.subscriptionsByMarkerId)
		for (let i = 0, len = subscriptionsByMarkerIdKeys.length; i < len; i++) {
			this.subscriptionsByMarkerId[subscriptionsByMarkerIdKeys[i]].dispose()
		}

		const decorationsByMarkerIdKeys = Object.keys(this.decorationsByMarkerId)
		for (let i = 0, len = decorationsByMarkerIdKeys.length; i < len; i++) {
			this.decorationsByMarkerId[decorationsByMarkerIdKeys[i]].destroy()
		}

		this.subscriptions.dispose()
		this.minimap = null
		this.editor = null
		this.decorationsByMarkerId = {}
		this.subscriptionsByMarkerId = {}
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
		const subscriptionsByMarkerIdKeys = Object.keys(this.subscriptionsByMarkerId)
		for (let i = 0, len = subscriptionsByMarkerIdKeys.length; i < len; i++) {
			const id = subscriptionsByMarkerIdKeys[i]
			this.subscriptionsByMarkerId[id].dispose()
			delete this.subscriptionsByMarkerId[id]
		}

		const decorationsByMarkerIdKeys = Object.keys(this.decorationsByMarkerId)
		for (let i = 0, len = decorationsByMarkerIdKeys.length; i < len; i++) {
			const id = decorationsByMarkerIdKeys[i]
			this.decorationsByMarkerId[id].destroy()
			delete this.decorationsByMarkerId[id]
		}
	}

	discoverMarkers () {
		setImmediate(() => {
			for (const marker of this.layer.getMarkers()) {
				this.createDecoration(marker)
			}
		})
	}

	createDecoration (marker) {
		if (!this.findViewIsVisible()) {
			return
		}
		if (this.decorationsByMarkerId[marker.id]) {
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

		const {
			id,
		} = marker
		this.decorationsByMarkerId[id] = decoration
		this.subscriptionsByMarkerId[id] = decoration.onDidDestroy(() => {
			this.subscriptionsByMarkerId[id].dispose()
			delete this.decorationsByMarkerId[id]
			delete this.subscriptionsByMarkerId[id]
		})
	}

	findViewIsVisible () {
		return (document.querySelector('.find-and-replace') !== null)
	}
}

module.exports = MinimapFindAndReplaceBinding
