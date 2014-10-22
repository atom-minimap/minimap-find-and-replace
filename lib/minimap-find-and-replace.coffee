
requirePackages = (packages...) ->
  new Promise (resolve, reject) ->
    required = []
    promises = []
    failures = []
    remains = packages.length

    solved = ->
      remains--
      return unless remains is 0
      return reject(failures) if failures.length > 0
      resolve(required)

    packages.forEach (pkg, i) ->
      promises.push(atom.packages.activatePackage(pkg)
      .then (activatedPackage) ->
        required[i] = activatedPackage.mainModule
        solved()
      .fail (reason) ->
        failures[i] = reason
        solved()
      )

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
