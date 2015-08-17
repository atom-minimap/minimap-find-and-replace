{CompositeDisposable} = require 'event-kit'
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

    @minimapsSubscription = @minimap.observeMinimaps (minimap) =>
      MinimapFindAndReplaceBinding ?= require './minimap-find-and-replace-binding'

      binding = new MinimapFindAndReplaceBinding(minimap)
      @bindingsById[minimap.id] = binding

      @subscriptionsById[minimap.id] = minimap.onDidDestroy =>
        @subscriptionsById[minimap.id].dispose()
        @bindingsById[minimap.id].destroy()

        delete @bindingsById[minimap.id]
        delete @subscriptionsById[minimap.id]

  deactivatePlugin: ->
    return unless @active

    @active = false
    @minimapsSubscription.dispose()
    @subscriptions.dispose()
