{CompositeDisposable} = require 'event-kit'

MARKER_CLASS = 'find-result'

module.exports =
class MinimapFindAndReplaceBinding
  constructor: (@minimap) ->
    @subscriptions = new CompositeDisposable
    @decorationsByMarkerId = {}
    @subscriptionsByMarkerId = {}

    editor = @minimap.getTextEditor()

    @subscriptions.add editor.displayBuffer.onDidCreateMarker (marker) =>
      properties = marker.getProperties()
      if properties?.class is MARKER_CLASS
        decoration = @minimap.decorateMarker(marker, {
          type: 'highlight'
          scope: ".minimap .search-result"
        })
        @decorationsByMarkerId[marker.id] = decoration
        @subscriptionsByMarkerId[marker.id] = decoration.onDidDestroy =>
          @subscriptionsByMarkerId[marker.id].dispose()
          delete @decorationsByMarkerId[marker.id]
          delete @subscriptionsByMarkerId[marker.id]

  destroy: ->
    decoration.destroy() for id,decoration of @decorationsByMarkerId
    sub.dispose() for id,sub of @subscriptionsByMarkerId

    @subscriptions.dispose()
    @minimap = null
    @decorationsByMarkerId = {}
    @subscriptionsByMarkerId = {}
