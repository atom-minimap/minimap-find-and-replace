
{requirePackages} = require 'atom-utils'

module.exports =
  binding: null

  activate: (state) ->

  consumeMinimapServiceV1: (minimap) ->
    requirePackages('find-and-replace').then ([find]) =>

      MinimapFindAndReplaceBinding = require './minimap-find-and-replace-binding'
      @binding = new MinimapFindAndReplaceBinding find, minimap

    .catch (reasons) ->
      console.log reasons

  deactivate: ->
    @binding?.deactivate()
    @minimapPackage = null
    @findPackage = null
    @binding = null
