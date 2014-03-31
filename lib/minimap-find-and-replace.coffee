MinimapFindAndReplaceBinding = require './minimap-find-and-replace-binding'

module.exports =
  binding: null
  activate: (state) ->
    findAndReplace = atom.packages.getLoadedPackage('find-and-replace')
    minimap = atom.packages.getLoadedPackage('minimap')

    return @deactivate() unless findAndReplace? and minimap?

    @binding = new MinimapFindAndReplaceBinding findAndReplace, minimap

  deactivate: ->
    @binding?.deactivate()
    @binding = null
