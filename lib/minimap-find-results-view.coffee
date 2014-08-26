{$} = require 'atom'
fs = require 'fs'

# HACK The exports is a function here because we are not sure that the
# `find-and-replace` and `minimap` packages will be available when this
# file is loaded. The binding instance will evaluate the module when
# created because at that point we're sure that both modules have been
# loaded.
module.exports = ->
  findAndReplace = atom.packages.getLoadedPackage('find-and-replace')
  minimap = atom.packages.getLoadedPackage('minimap')

  minimapInstance = require (minimap.path)
  FindResultsView = require './find-results-view'

  class MinimapFindResultsView extends FindResultsView
    attach: ->
      minimap = @getMinimap()

      if minimap?
        minimap.miniOverlayer.append(this)
        @patchMarkers()

    getEditor: ->
      activeView = atom.workspaceView.getActiveView()
      if activeView?.hasClass('editor') then activeView else null

    getMinimap: ->
      editorView = @getEditor()
      return minimapInstance.minimapForEditorView(editorView) if editorView?

    # HACK We don't want the markers to disappear when they're not
    # visible in the editor visible area so we'll hook on the
    # `markersUpdated` method and replace the corresponding method
    # on the fly.
    markersUpdated: (markers) ->
      minimap = @getMinimap()
      super(markers)
      @patchMarkers()

    patchMarkers: ->
      for k,marker of @markerViews
        marker.intersectsRenderedScreenRows = (range) ->
          return false unless minimap?
          range.intersectsRowRange(minimap.miniEditorView.firstRenderedScreenRow, minimap.miniEditorView.lastRenderedScreenRow)

        marker.editor = minimap
        marker.updateNeeded = true
        marker.updateDisplay()
