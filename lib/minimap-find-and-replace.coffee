MinimapFindAndReplaceView = require './minimap-find-and-replace-view'

module.exports =
  minimapFindAndReplaceView: null

  activate: (state) ->
    @minimapFindAndReplaceView = new MinimapFindAndReplaceView(state.minimapFindAndReplaceViewState)

  deactivate: ->
    @minimapFindAndReplaceView.destroy()

  serialize: ->
    minimapFindAndReplaceViewState: @minimapFindAndReplaceView.serialize()
