{EditorView} = require 'atom'

module.exports = ->
  findAndReplace = atom.packages.getLoadedPackage('find-and-replace')
  minimap = atom.packages.getLoadedPackage('minimap')

  minimapInstance = require (minimap.path)
  FindResultsView = require (findAndReplace.path + '/lib/find-results-view')

  class MinimapFindResultsView extends FindResultsView
    attach: ->
      @getMinimap()?.miniOverlayer.append(this)
      @width @getEditor().width()

    getMinimap: ->
      minimapInstance.minimapForEditorView(@getEditor())

    # HACK We don't want the marker to disappear when there not visible in the
    # editor visible area so we'll hook on the `markersUpdated` method and
    # replace the corresponding method on the fly.
    markersUpdated: (markers) ->
      super(markers)
      for k,marker of @markerViews
        marker.intersectsRenderedScreenRows = -> true
