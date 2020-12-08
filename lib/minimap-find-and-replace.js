/** @babel */

const { CompositeDisposable } = require('atom')
let MinimapFindAndReplaceBinding = null

module.exports = {
	isActive () {
		return this.active
	},

	activate (state) {
		this.active = false
		this.fnrVisible = false
		this.bindingsById = {}
		this.subscriptionsById = {}
		this.subscriptions = new CompositeDisposable()
		require('atom-package-deps').install('minimap-find-and-replace')
	},

	consumeMinimapServiceV1 (minimap) {
		this.minimap = minimap
		this.minimap.registerPlugin('find-and-replace', this)
	},

	deactivate () {
		this.minimap.unregisterPlugin('find-and-replace')
		this.minimap = null
	},

	activatePlugin () {
		if (this.active) {
			return
		}

		this.active = true

		this.initializeServiceAPI()
	},

	initializeServiceAPI () {
		atom.packages.serviceHub.consume('find-and-replace', '0.0.1', fnr => {
			this.setOnChangeVisibility()

			this.subscriptions.add(this.minimap.observeMinimaps(minimap => {
				if (!MinimapFindAndReplaceBinding) {
					MinimapFindAndReplaceBinding = require('./minimap-find-and-replace-binding')
				}

				const {
					id,
				} = minimap
				const binding = new MinimapFindAndReplaceBinding(minimap, fnr, this.fnrVisible)
				this.bindingsById[id] = binding

				this.subscriptionsById[id] = minimap.onDidDestroy(() => {
					if (this.subscriptionsById[id]) {
						this.subscriptionsById[id].dispose()
					}
					if (this.bindingsById[id]) {
						this.bindingsById[id].destroy()
					}

					delete this.bindingsById[id]
					delete this.subscriptionsById[id]
				})
			}))
		})
	},

	setOnChangeVisibility (retry = 0) {
		const [fnrPanel] = atom.workspace.getBottomPanels().filter(panel => panel.element.firstChild.classList.contains('find-and-replace'))

		if (fnrPanel) {
			this.changeVisible(fnrPanel.isVisible())
			this.subscriptions.add(fnrPanel.onDidChangeVisible((visible) => {
				this.changeVisible(visible)
			}))
		} else {
			if (retry < 10) {
				setTimeout(() => this.setOnChangeVisibility(retry + 1), 100)
			} else {
				// eslint-disable-next-line no-console
				console.error("Couldn't find find-and-replace")
			}
		}
	},

	changeVisible (visible) {
		this.fnrVisible = visible
		for (const id in this.bindingsById) {
			this.bindingsById[id].changeVisible(visible)
		}
	},

	deactivatePlugin () {
		let id
		if (!this.active) {
			return
		}

		this.active = false
		this.subscriptions.dispose()

		for (id in this.subscriptionsById) {
			const sub = this.subscriptionsById[id]; sub.dispose()
		}
		for (id in this.bindingsById) {
			const binding = this.bindingsById[id]; binding.destroy()
		}

		this.bindingsById = {}
		this.subscriptionsById = {}
	},
}
