{CompositeDisposable} = require 'atom'
FindAndReplace = null

module.exports =
class MinimapFindAndReplaceBinding
  constructor: (@minimap) ->
    @editor = @minimap.getTextEditor()
    @subscriptions = new CompositeDisposable
    @decorationsByMarkerId = {}
    @subscriptionsByMarkerId = {}

    @discoverMarkers()

    @subscriptions.add @editor.displayBuffer.onDidCreateMarker (marker) =>
      @handleCreatedMarker(marker)

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

  findAndReplace: -> FindAndReplace ?= atom.packages.getLoadedPackage('find-and-replace').mainModule

  discoverMarkers: ->
    @editor.findMarkers(class: 'find-result').forEach (marker) =>
      @createDecoration(marker)

  handleCreatedMarker: (marker) ->
    @createDecoration(marker) if marker.getProperties()?.class is 'find-result'

  createDecoration: (marker) ->
    return unless @findViewIsVisible()
    return if @decorationsByMarkerId[marker.id]?

    decoration = @minimap.decorateMarker(marker, {
      type: 'highlight'
      scope: ".minimap .search-result"
    })
    @decorationsByMarkerId[marker.id] = decoration
    @subscriptionsByMarkerId[marker.id] = decoration.onDidDestroy =>
      @subscriptionsByMarkerId[marker.id].dispose()
      delete @decorationsByMarkerId[marker.id]
      delete @subscriptionsByMarkerId[marker.id]

  findViewIsVisible: -> @findAndReplace()?.findView?.is(':visible')
