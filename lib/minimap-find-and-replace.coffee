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

    @initializeServiceAPI()

  initializeServiceAPI: ->
    atom.packages.serviceHub.consume 'find-and-replace', '0.0.1', (fnr) =>
      @setOnChangeVisibility()

      @subscriptions.add @minimap.observeMinimaps (minimap) =>
        MinimapFindAndReplaceBinding ?= require './minimap-find-and-replace-binding'

        id = minimap.id
        binding = new MinimapFindAndReplaceBinding(minimap, fnr)
        @bindingsById[id] = binding

        @subscriptionsById[id] = minimap.onDidDestroy =>
          @subscriptionsById[id]?.dispose()
          @bindingsById[id]?.destroy()

          delete @bindingsById[id]
          delete @subscriptionsById[id]

  setOnChangeVisibility: (num = 1) ->
    [fnrPanel] = atom.workspace.getBottomPanels().filter (panel) ->
      return panel.element.firstChild.classList.contains "find-and-replace"

    if fnrPanel
      fnrPanel.onDidChangeVisible (visible) =>
        if visible
          @discoverMarkers()
        else
          @clearBindings()

    else
      if num < 10
        setTimeout (=> @setOnChangeVisibility(num + 1)), 100
      else
        console.error "Couldn't find find-and-replace"

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
