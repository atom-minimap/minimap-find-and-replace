{CompositeDisposable} = require 'atom'
MinimapFindAndReplaceBinding = null

module.exports =
  active: false
  bindingsById: {}
  subscriptionsById: {}

  isActive: -> @active

  activate: (state) ->
    @subscriptions = new CompositeDisposable

  consumeMinimapServiceV1: (@minimap) ->
    @minimap.registerPlugin 'find-and-replace', this

  deactivate: ->
    @minimap.unregisterPlugin 'find-and-replace'
    @minimap = null

  activatePlugin: ->
    return if @active

    @active = true

    @subscriptions.add @minimap.observeMinimaps (minimap) =>
      MinimapFindAndReplaceBinding ?= require './minimap-find-and-replace-binding'

      binding = new MinimapFindAndReplaceBinding(minimap)
      @bindingsById[minimap.id] = binding

      @subscriptionsById[minimap.id] = minimap.onDidDestroy =>
        @subscriptionsById[minimap.id]?.dispose()
        @bindingsById[minimap.id]?.destroy()

        delete @bindingsById[minimap.id]
        delete @subscriptionsById[minimap.id]

    @subscriptions.add atom.commands.add 'atom-workspace',
      'find-and-replace:show': => @discoverMarkers()
      'find-and-replace:toggle': => @discoverMarkers()
      'find-and-replace:show-replace': => @discoverMarkers()
      'core:cancel': => @clearBindings()
      'core:close': => @clearBindings()

  deactivatePlugin: ->
    return unless @active

    @active = false
    @subscriptions.dispose()

    sub.dispose() for id,sub of @subscriptionsById
    binding.destroy() for id,binding of @bindingsById

    @bindingsById = {}
    @subscriptionsById = {}

  discoverMarkers: ->
    binding.discoverMarkers() for id,binding of @bindingsById

  clearBindings: ->
    binding.clear() for id,binding of @bindingsById
