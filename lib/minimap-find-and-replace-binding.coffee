_ = require 'underscore-plus'
{$} = require 'atom'
{Subscriber, Emitter} = require 'emissary'
MinimapFindResultsView = null

module.exports =
class MinimapFindAndReplaceBinding
  Subscriber.includeInto(this)
  Emitter.includeInto(this)

  active: false

  constructor: (@findAndReplacePackage, @minimapPackage) ->
    @minimap = require(@minimapPackage.path)
    @findAndReplace = require(@findAndReplacePackage.path)

    MinimapFindResultsView = require('./minimap-find-results-view')()

    $(document).on 'find-and-replace:show', @activate
    atom.workspaceView.on 'core:cancel core:close', @deactivate
    @subscribe @minimap, 'activated.minimap', @activate
    @subscribe @minimap, 'deactivated.minimap', @deactivate

  activate: =>
    return @deactivate() unless @findViewIsVisible() and @minimapIsActive()
    return if @active
    @active = true

    @findView = @findAndReplace.findView
    @findModel = @findView.findModel
    @findResultsView = new MinimapFindResultsView(@findModel)

    @subscribe @findModel, 'updated', @markersUpdated

    setImmediate =>
    console.log 'activated'
      @findModel.emit('updated', _.clone(@findModel.markers))

  deactivate: =>
    return unless @active
    @active = false

    @findResultsView.detach()
    @unsubscribe @findModel, 'updated'
    console.log 'deactivated'

  destroy: ->
    @deactivate()

    $(document).off 'find-and-replace:show'
    atom.workspaceView.off 'core:cancel core:close'
    @unsubscribe()

    @findAndReplacePackage = null
    @findAndReplace = null
    @minimapPackage = null
    @minimap = null

  findViewIsVisible: -> @findAndReplace.findView?.parent().length isnt 0

  minimapIsActive: -> @minimap.active

  markersUpdated: =>
    @findResultsView.detach()
    @findResultsView.attach()
