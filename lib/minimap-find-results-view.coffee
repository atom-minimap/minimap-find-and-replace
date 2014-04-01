{EditorView} = require 'atom'

# HACK The exports is a function here because we are not sure that the
# `find-and-replace` and `minimap` packages will be available when this
# file is loaded. The binding instance will evaluate the module when
# created because at that point we're sure that both modules have been
# loaded.
module.exports = ->
  findAndReplace = atom.packages.getLoadedPackage('find-and-replace')
  minimap = atom.packages.getLoadedPackage('minimap')

  minimapInstance = require (minimap.path)
  FindResultsView = require (findAndReplace.path + '/lib/find-results-view')

  class MinimapFindResultsView extends FindResultsView
    attach: ->
      @getMinimap()?.miniOverlayer.append(this)
      @css '-webkit-tranform', 'scale3d(0.7,1,1)'

    getMinimap: ->
      minimapInstance.minimapForEditorView(@getEditor())

    # HACK We don't want the markers to disappear when there not visible in the
    # editor visible area so we'll hook on the `markersUpdated` method and
    # replace the corresponding method on the fly.
    markersUpdated: (markers) ->
      super(markers)
      for k,marker of @markerViews
        marker.intersectsRenderedScreenRows = -> true
