/** @babel */

const {CompositeDisposable} = require("atom");
let MinimapFindAndReplaceBinding = null;

module.exports = {
	active: false,
	bindingsById: {},
	subscriptionsById: {},

	isActive() {
		return this.active;
	},

	activate(state) {
		this.subscriptions = new CompositeDisposable();
	},

	consumeMinimapServiceV1(minimap) {
		this.minimap = minimap;
		this.minimap.registerPlugin("find-and-replace", this);
	},

	deactivate() {
		this.minimap.unregisterPlugin("find-and-replace");
		this.minimap = null;
	},

	activatePlugin() {
		if (this.active) {
			return;
		}

		this.active = true;

		this.initializeServiceAPI();
	},

	initializeServiceAPI() {
		atom.packages.serviceHub.consume("find-and-replace", "0.0.1", fnr => {
			this.setOnChangeVisibility();

			this.subscriptions.add(this.minimap.observeMinimaps(minimap => {
				if (!MinimapFindAndReplaceBinding) {
					MinimapFindAndReplaceBinding = require("./minimap-find-and-replace-binding");
				}

				const {
					id
				} = minimap;
				const binding = new MinimapFindAndReplaceBinding(minimap, fnr);
				this.bindingsById[id] = binding;

				this.subscriptionsById[id] = minimap.onDidDestroy(() => {
					if (this.subscriptionsById[id]) {
						this.subscriptionsById[id].dispose();
					}
					if (this.bindingsById[id]) {
						this.bindingsById[id].destroy();
					}

					delete this.bindingsById[id];
					delete this.subscriptionsById[id];
				});
			}));
		});
	},

	setOnChangeVisibility(num = 1) {
		const [fnrPanel] = atom.workspace.getBottomPanels().filter(panel => panel.element.firstChild.classList.contains("find-and-replace"));

		if (fnrPanel) {
			fnrPanel.onDidChangeVisible(visible => {
				if (visible) {
					this.discoverMarkers();
				} else {
					this.clearBindings();
				}
			});

		} else {
			if (num < 10) {
				setTimeout((() => this.setOnChangeVisibility(num + 1)), 100);
			} else {
				// eslint-disable-next-line no-console
				console.error("Couldn't find find-and-replace");
			}
		}
	},

	deactivatePlugin() {
		let id;
		if (!this.active) {
			return;
		}

		this.active = false;
		this.subscriptions.dispose();

		for (id in this.subscriptionsById) {
			const sub = this.subscriptionsById[id]; sub.dispose();
		}
		for (id in this.bindingsById) {
			const binding = this.bindingsById[id]; binding.destroy();
		}

		this.bindingsById = {};
		this.subscriptionsById = {};
	},

	discoverMarkers() {
		for (const id in this.bindingsById) {
			this.bindingsById[id].discoverMarkers();
		}
	},

	clearBindings() {
		for (const id in this.bindingsById) {
			this.bindingsById[id].clear();
		}
	}
};
