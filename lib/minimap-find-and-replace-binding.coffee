_ = require 'underscore-plus'
{Subscriber, Emitter} = require 'emissary'
{CompositeDisposable} = require 'event-kit'
MinimapFindResultsView = null

PLUGIN_NAME = 'find-and-replace'

module.exports =
class MinimapFindAndReplaceBinding
  Emitter.includeInto(this)

  active: false
  pluginActive: false
  isActive: -> @pluginActive

  constructor: (@findAndReplace, @minimap) ->
    @subscriptions = new CompositeDisposable

    @minimap.registerPlugin PLUGIN_NAME, this

  activatePlugin: ->
    @pluginActive = true
    @subscriptions.add atom.commands.add 'atom-workspace',
      'find-and-replace:show': @activate
      'find-and-replace:toggle': @activate
      'find-and-replace:show-replace': @activate
      'core:cancel': @deactivate
      'core:close': @deactivate

    @subscriptions.add @minimap.onDidActivate @activate
    @subscriptions.add @minimap.onDidDeactivate @deactivate

    @activate() if @findViewIsVisible()

  deactivatePlugin: ->
    @pluginActive = false
    @subscriptions.dispose()
    @deactivate()

  activate: =>
    return unless @pluginActive
    return @deactivate() unless @findViewIsVisible()
    return if @active

    MinimapFindResultsView ||= require('./minimap-find-results-view')(@findAndReplace, @minimap)

    @active = true

    @findView = @findAndReplace.findView
    @findModel = @findView.findModel
    @findResultsView = new MinimapFindResultsView(@findModel)

    setImmediate =>
      @findModel.emitter.emit('did-update', _.clone(@findModel.markers))

  deactivate: =>
    return unless @active
    @findResultsView?.destroy()
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
