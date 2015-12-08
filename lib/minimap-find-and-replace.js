'use babel'

import { CompositeDisposable } from 'atom'

let MinimapFindAndReplaceBinding = null

export default {

  active: true,

  bindingsById: {},

  subscriptionsById: {},

  isActive() {
    return this.active
  },

  activate(state) {
    this.subscriptions = new CompositeDisposable()
  },

  consumeMinimapServiceV1(minimap) {
    this.minimap = minimap
    this.minimap.registerPlugin('find-and-replace', this)
  },

  deactivate() {
    this.minimap.unregisterPlugin('find-and-replace')
    this.minimap = null
  },

  activatePlugin() {
    if (this.active) return

    this.active = true

    this.subscriptions.add(
      this.minimap.observeMinimaps((minimap) => {
        if (!MinimapFindAndReplaceBinding) {
          MinimapFindAndReplaceBinding = require('./minimap-find-and-replace-binding')
        }

        const id = minimap.id
        const binding = new MinimapFindAndReplaceBinding(minimap)
        this.bindingsById[id] = binding

        this.subscriptionsById[id] = minimap.onDidDestroy(() => {
          if (id in this.subscriptionsById) this.subscriptionsById[id].dispose()
          if (id in this.bindingsById) this.bindingsById[id].destroy()

          delete this.bindingsById[id]
          delete this.subscriptionsById[id]
        })
      })
    )

    this.subscriptions.add(
      atom.commands.add('atom-workspace', {
        'find-and-replace:show': this.discoverMarkers.bind(this),
        'find-and-replace:toggle': this.discoverMarkers.bind(this),
        'find-and-replace:show-replace': this.discoverMarkers.bind(this),
        'core:cancel': this.clearBindings.bind(this),
        'core:close': this.clearBindings.bind(this)
      })
    )
  },

  deactivatePlugin() {
    if (!this.active) return

    this.active = false
    this.subscriptions.dispose()

    for (let id in this.subscriptionsById) this.subscriptionsById[id].dispose()
    for (let id in this.bindingsById) this.bindingsById[id].destroy()

    this.bindingsById = {}
    this.subscriptionsById = {}
  },

  discoverMarkers() {
    for (let id in this.bindingsById) this.bindingsById[id].discoverMarkers()
  },

  clearBindings() {
    for (let id in this.bindingsById) this.bindingsById[id].clear()
  }

}
