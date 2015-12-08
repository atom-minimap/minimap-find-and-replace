'use babel'

import { CompositeDisposable } from 'atom'

let FindAndReplace = null

export default class MinimapFindAndReplaceBinding {

  constructor(minimap) {
    this.minimap = minimap
    this.editor = this.minimap.getTextEditor()
    this.subscriptions = new CompositeDisposable()
    this.decorationsByMarkerId = {}
    this.subscriptionsByMarkerId = {}

    this.discoverMarkers()

    this.subscriptions.add(
      this.editor.displayBuffer.onDidCreateMarker((marker) => {
        return this.handleCreatedMarker(marker)
      })
    )
  }

  destroy() {
    for (let id in this.subscriptionsByMarkerId)
      this.subscriptionsByMarkerId[id].dispose()

    for (let id in this.decorationsByMarkerId)
      this.decorationsByMarkerId[id].destroy()

    this.subscriptions.dispose()
    this.minimap = null
    this.editor = null
    this.decorationsByMarkerId = {}
    this.subscriptionsByMarkerId = {}
  }

  clear() {
    for (let id in this.subscriptionsByMarkerId) {
      this.subscriptionsByMarkerId[id].dispose()
      delete this.subscriptionsByMarkerId[id]
    }

    for (let id in this.decorationsByMarkerId) {
      this.decorationsByMarkerId[id].destroy()
      delete this.decorationsByMarkerId[id]
    }
  }

  findAndReplace() {
    if (!FindAndReplace) {
      FindAndReplace = atom.packages
        .getLoadedPackage('find-and-replace')
        .mainModule
    }
    return FindAndReplace
  }

  discoverMarkers() {
    this.editor.findMarkers({ 'class': 'find-result' })
      .forEach(marker => this.createDecoration(marker))
  }

  handleCreatedMarker(marker) {
    const props = marker.getProperties()
    if (props && props['class'] === 'find-result') {
      this.createDecoration(marker)
    }
  }

  createDecoration(marker) {
    if (!this.findViewIsVisible()) return

    const id = marker.id

    if (this.decorationsByMarkerId[id]) return

    const decoration = this.minimap.decorateMarker(marker, {
      type: 'highlight'
      scope: '.minimap .search-result'
    })

    if (!decoration) return

    this.decorationsByMarkerId[id] = decoration
    this.subscriptionsByMarkerId[id] = decoration.onDidDestroy(() => {
      this.subscriptionsByMarkerId[id].dispose()
      delete this.decorationsByMarkerId[id]
      delete this.subscriptionsByMarkerId[id]
    })
  }

  findViewIsVisible() {
    const view = this.findAndReplace()
    return view && view.findView && view.findView.is(':visible')
  }
}
