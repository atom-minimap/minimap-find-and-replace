{Subscriber} = require 'emissary'

module.exports = ->
  findAndReplace = atom.packages.getLoadedPackage('find-and-replace')
  minimap = atom.packages.getLoadedPackage('minimap')

  minimapInstance = require (minimap.path)

  class MinimapFindResultsView
    Subscriber.includeInto(this)

    constructor: (@model) ->
      @subscribe @model, 'updated', @markersUpdated
      atom.workspaceView.on 'pane-container:active-pane-item-changed', => @activePaneItemChanged()
      @decorationsByMarkerId = {}

    destroy: ->
      @unsubscribe()
      @destroyDecorations()
      @decorationsByMarkerId = {}
      @markers = null

    destroyDecorations: ->
      decoration.destroy() for id, decoration of @decorationsByMarkerId

    getMinimap: -> minimapInstance.getActiveMinimap()

    markersUpdated: (markers) =>
      minimap = @getMinimap()
      return unless minimap?

      for marker in markers
        decoration = minimap.decorateMarker(marker, type: 'highlight', scope: '.minimap .search-result')
        @decorationsByMarkerId[marker.id] = decoration

    activePaneItemChanged: ->
      @destroyDecorations()
      setImmediate => @markersUpdated(@model.markers) if @markers?
