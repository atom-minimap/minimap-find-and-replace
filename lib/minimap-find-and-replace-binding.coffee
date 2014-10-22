_ = require 'underscore-plus'
{$} = require 'atom'
{Subscriber, Emitter} = require 'emissary'
MinimapFindResultsView = null

PLUGIN_NAME = 'find-and-replace'

module.exports =
class MinimapFindAndReplaceBinding
  Subscriber.includeInto(this)
  Emitter.includeInto(this)

  active: false
  pluginActive: false
  isActive: -> @pluginActive

  constructor: (@findAndReplace, @minimap) ->
    MinimapFindResultsView = require('./minimap-find-results-view')()

    @minimap.registerPlugin PLUGIN_NAME, this

  activatePlugin: ->
    $(window).on 'find-and-replace:show find-and-replace:toggle find-and-replace:show-replace', @activate
    atom.workspaceView.on 'core:cancel core:close', @deactivate
    @subscribe @minimap, 'activated.minimap', @activate
    @subscribe @minimap, 'deactivated.minimap', @deactivate

    @activate() if @findViewIsVisible() and @minimapIsActive()
    @pluginActive = true

  deactivatePlugin: ->
    $(window).off 'find-and-replace:show'
    atom.workspaceView.off 'core:cancel core:close'
    @unsubscribe()
    @deactivate()
    @pluginActive = false

  activate: =>
    return @deactivate() unless @findViewIsVisible() and @minimapIsActive()
    return if @active
    @active = true

    @findView = @findAndReplace.findView
    @findModel = @findView.findModel
    @findResultsView = new MinimapFindResultsView(@findModel)

    setImmediate =>
      @findModel.emit('updated', _.clone(@findModel.markers))

  deactivate: =>
    return unless @active
    @findResultsView.destroy()
    @active = false

  destroy: ->
    @deactivate()

    @findAndReplacePackage = null
    @findAndReplace = null
    @minimapPackage = null
    @findResultsView = null
    @minimap = null

  findViewIsVisible: ->
    @findAndReplace.findView? and @findAndReplace.findView.parent().length is 1

  minimapIsActive: -> @minimap.active
