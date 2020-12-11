/** @babel */

const { CompositeDisposable } = require('atom')
let MinimapFindAndReplaceBinding = null

module.exports = {
	isActive () {
		return this.active
	},

	activate () {
		this.active = false
		this.fnrVisible = false
		this.bindingsById = new Map()
		this.subscriptionsById = new Map()
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

				const { id } = minimap
				const binding = new MinimapFindAndReplaceBinding(minimap, fnr, this.fnrVisible)
				this.bindingsById.set(id, binding)

				this.subscriptionsById.set(id,
					minimap.onDidDestroy(() => {
						if (this.subscriptionsById.has(id)) {
							this.subscriptionsById.get(id).dispose()
						}
						if (this.bindingsById.has(id)) {
							this.bindingsById.get(id).destroy()
						}

						this.bindingsById.delete(id)
						this.subscriptionsById.delete(id)
					}),
				)
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
		const bindings = this.bindingsById.values()
		for (const binding of bindings) {
			binding.changeVisible(visible)
		}
	},

	deactivatePlugin () {
		if (!this.active) {
			return
		}

		this.active = false
		this.subscriptions.dispose()

		const subscriptions = this.subscriptionsById.values()
		for (const subscription of subscriptions) {
			subscription.dispose()
		}

		const bindings = this.bindingsById.values()
		for (const binding of bindings) {
			binding.destroy()
		}

		this.bindingsById = {}
		this.subscriptionsById = {}
	},
}
