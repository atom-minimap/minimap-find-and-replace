findAndReplace = atom.packages.getLoadedPackage('find-and-replace')

FindResultsView = require (findAndReplace.path + '/lib/find-results-view')

module.exports =
class MinimapFindResultsView extends FindResultsView
  attach: -> @getMinimap()?.miniOverlayer.append(this)

  getMinimap: ->
    activeView = atom.workspaceView.getActiveView()
    if activeView instanceof EditorView then
      # Fetch minimap for editor view
    else null
