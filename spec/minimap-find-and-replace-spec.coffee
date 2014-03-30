MinimapFindAndReplace = require '../lib/minimap-find-and-replace'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "MinimapFindAndReplace", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('minimapFindAndReplace')

  describe "when the minimap-find-and-replace:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.minimap-find-and-replace')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'minimap-find-and-replace:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.minimap-find-and-replace')).toExist()
        atom.workspaceView.trigger 'minimap-find-and-replace:toggle'
        expect(atom.workspaceView.find('.minimap-find-and-replace')).not.toExist()
