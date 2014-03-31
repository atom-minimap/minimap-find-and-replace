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
