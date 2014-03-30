{View} = require 'atom'

module.exports =
class MinimapFindAndReplaceView extends View
  @content: ->
    @div class: 'minimap-find-and-replace overlay from-top', =>
      @div "The MinimapFindAndReplace package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "minimap-find-and-replace:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "MinimapFindAndReplaceView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
