{CompositeDisposable} = require 'event-kit'

module.exports = (findAndReplace, minimapPackage) ->

  class MinimapFindResultsView

    constructor: (@model) ->
      @subscriptions = new CompositeDisposable
      @subscriptions.add @model.onDidUpdate @markersUpdated
      @decorationsByMarkerId = {}

    destroy: ->
      @subscriptions.dispose()
      @destroyDecorations()
      @decorationsByMarkerId = {}
      @markers = null

    destroyDecorations: ->
      for id, decoration of @getMinimap().decorationsById
        if decoration.getProperties().scope is '.minimap .search-result'
          decoration.destroy()

    getMinimap: -> minimapPackage.getActiveMinimap()

    markersUpdated: (markers) =>
      minimap = @getMinimap()
      return unless minimap?

      for marker in markers
        decoration = minimap.decorateMarker(marker, type: 'highlight', scope: '.minimap .search-result')
        @decorationsByMarkerId[marker.id] = decoration

    activePaneItemChanged: ->
      @destroyDecorations()
      setImmediate => @markersUpdated(@model.markers) if @markers?
