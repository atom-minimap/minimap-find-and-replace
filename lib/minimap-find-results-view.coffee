{$, EditorView} = require 'atom'

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
      minimap = @getMinimap()
      minimap.miniOverlayer.append(this)

      @adjustResults()

    # As there's a slightly different char width between the minimap font
    # and the editor font we'll retrieve both widths and compute the ratio
    # to properly scale the find results.
    adjustResults: ->
      return if @adjusted

      minimapFirstLine = minimap.miniEditorView.find('.line').first()
      editorFirstLine = @getEditor().find('.line').first()

      console.log minimapFirstLine.html()
      console.log editorFirstLine.html()

      minimapWidth = minimapFirstLine.children().width()
      editorWidth = editorFirstLine.children().width()
      ratio = minimapWidth / editorWidth

      @css '-webkit-transform', "scale3d(#{ratio},1,1)"

      @adjusted = true

    getMinimap: ->
      minimapInstance.minimapForEditorView(@getEditor())

    # HACK We don't want the markers to disappear when there not visible in the
    # editor visible area so we'll hook on the `markersUpdated` method and
    # replace the corresponding method on the fly.
    markersUpdated: (markers) ->
      super(markers)
      for k,marker of @markerViews
        marker.intersectsRenderedScreenRows = -> true
