{CompositeDisposable} = require 'atom'
FindAndReplace = null

module.exports =
class MinimapFindAndReplaceBinding
  constructor: (@minimap, @fnrAPI) ->
    @editor = @minimap.getTextEditor()
    @subscriptions = new CompositeDisposable
    @decorationsByMarkerId = {}
    @subscriptionsByMarkerId = {}

    @layer = @fnrAPI.resultsMarkerLayerForTextEditor(@editor)

    @subscriptions.add @layer.onDidUpdate => @discoverMarkers()

    @discoverMarkers()

  destroy: ->
    sub.dispose() for id,sub of @subscriptionsByMarkerId
    decoration.destroy() for id,decoration of @decorationsByMarkerId

    @subscriptions.dispose()
    @minimap = null
    @editor = null
    @decorationsByMarkerId = {}
    @subscriptionsByMarkerId = {}

  clear: ->
    for id,sub of @subscriptionsByMarkerId
      sub.dispose()
      delete @subscriptionsByMarkerId[id]

    for id,decoration of @decorationsByMarkerId
      decoration.destroy()
      delete @decorationsByMarkerId[id]

  discoverMarkers: ->
    setImmediate( => @createDecoration(marker) for marker in @layer.getMarkers())

  createDecoration: (marker) ->
    return unless @findViewIsVisible()
    return if @decorationsByMarkerId[marker.id]?

    decoration = @minimap.decorateMarker(marker, {
      type: 'highlight'
      scope: ".minimap .search-result"
      plugin: 'find-and-replace'
    })

    return unless decoration?

    id = marker.id
    @decorationsByMarkerId[id] = decoration
    @subscriptionsByMarkerId[id] = decoration.onDidDestroy =>
      @subscriptionsByMarkerId[id].dispose()
      delete @decorationsByMarkerId[id]
      delete @subscriptionsByMarkerId[id]

  findViewIsVisible: ->
    document.querySelector('.find-and-replace')?
