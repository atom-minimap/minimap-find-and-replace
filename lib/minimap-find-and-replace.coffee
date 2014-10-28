
{requirePackages} = require 'atom-utils'

module.exports =
  binding: null

  activate: (state) ->
    requirePackages('minimap', 'find-and-replace').then ([minimap, find]) ->
      return @deactivate() unless minimap.versionMatch('3.x')

      MinimapFindAndReplaceBinding = require './minimap-find-and-replace-binding'
      @binding = new MinimapFindAndReplaceBinding find, minimap

    .catch (reasons) ->
      console.log reasons

  deactivate: ->
    @binding?.deactivate()
    @minimapPackage = null
    @findPackage = null
    @binding = null
