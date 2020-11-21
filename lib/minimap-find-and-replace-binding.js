/** @babel */

const {CompositeDisposable} = require("atom");

class MinimapFindAndReplaceBinding {
	constructor(minimap, fnrAPI) {
		this.minimap = minimap;
		this.fnrAPI = fnrAPI;
		this.editor = this.minimap.getTextEditor();
		this.subscriptions = new CompositeDisposable();
		this.decorationsByMarkerId = {};
		this.subscriptionsByMarkerId = {};

		this.layer = this.fnrAPI.resultsMarkerLayerForTextEditor(this.editor);

		this.subscriptions.add(this.layer.onDidUpdate(() => this.discoverMarkers()));

		this.discoverMarkers();
	}

	destroy() {
		let id;
		for (id in this.subscriptionsByMarkerId) {
			const sub = this.subscriptionsByMarkerId[id]; sub.dispose();
		}
		for (id in this.decorationsByMarkerId) {
			const decoration = this.decorationsByMarkerId[id]; decoration.destroy();
		}

		this.subscriptions.dispose();
		this.minimap = null;
		this.editor = null;
		this.decorationsByMarkerId = {};
		this.subscriptionsByMarkerId = {};
	}

	clear() {
		let id;
		for (id in this.subscriptionsByMarkerId) {
			const sub = this.subscriptionsByMarkerId[id];
			sub.dispose();
			delete this.subscriptionsByMarkerId[id];
		}

		for (id in this.decorationsByMarkerId) {
			const decoration = this.decorationsByMarkerId[id];
			decoration.destroy();
			delete this.decorationsByMarkerId[id];
		}
	}

	discoverMarkers() {
		setImmediate(() => {
			for (const marker of this.layer.getMarkers()) {
				this.createDecoration(marker);
			}
		});
	}

	createDecoration(marker) {
		if (!this.findViewIsVisible()) {
			return;
		}
		if (this.decorationsByMarkerId[marker.id]) {
			return;
		}

		const decoration = this.minimap.decorateMarker(marker, {
			type: "highlight",
			scope: ".minimap .search-result",
			plugin: "find-and-replace"
		});

		if (!decoration) {
			return;
		}

		const {
			id
		} = marker;
		this.decorationsByMarkerId[id] = decoration;
		this.subscriptionsByMarkerId[id] = decoration.onDidDestroy(() => {
			this.subscriptionsByMarkerId[id].dispose();
			delete this.decorationsByMarkerId[id];
			delete this.subscriptionsByMarkerId[id];
		});
	}

	findViewIsVisible() {
		return (document.querySelector(".find-and-replace") !== null);
	}
}

module.exports = MinimapFindAndReplaceBinding;
