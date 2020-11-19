MinimapFindAndReplace = require '../lib/minimap-find-and-replace'

describe 'MinimapFindAndReplace', ->
  [workspace] = []

  beforeEach ->
    workspace = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspace)

    waitsForPromise ->
      atom.packages.activatePackage('minimap')

    waitsForPromise ->
      promise = atom.packages.activatePackage('find-and-replace')
      atom.commands.dispatch(workspace, 'find-and-replace:show')
      promise

  describe 'when the package is activated', ->
    beforeEach ->
      waitsForPromise -> atom.packages.activatePackage('minimap-find-and-replace')

    it 'should activate', ->
      expect(MinimapFindAndReplace.isActive()).toBe(true)

    describe 'when find-and-replace is closed', ->
      beforeEach ->
        atom.commands.dispatch(workspace, 'find-and-replace:show')
        spyOn(MinimapFindAndReplace, "clearBindings")

      it "should clear on core:cancel", ->
        atom.commands.dispatch(workspace, "core:cancel")
        expect(MinimapFindAndReplace.clearBindings.calls.length).toBe(1)

      it "should clear on find-and-replace:toggle", ->
        atom.commands.dispatch(workspace, "find-and-replace:toggle")
        atom.commands.dispatch(workspace, "find-and-replace:toggle")
        expect(MinimapFindAndReplace.clearBindings.calls.length).toBe(1)

      it "should clear on close button pressed", ->
        document.querySelector(".find-and-replace .close-button").click()
        expect(MinimapFindAndReplace.clearBindings.calls.length).toBe(1)

    describe 'when find-and-replace is opened', ->
      beforeEach ->
        atom.commands.dispatch(workspace, 'core:cancel')
        spyOn(MinimapFindAndReplace, "discoverMarkers")

      it "should display markers on find-and-replace:show", ->
        atom.commands.dispatch(workspace, "find-and-replace:show")
        expect(MinimapFindAndReplace.discoverMarkers.calls.length).toBe(1)

      it "should display markers on find-and-replace:show-replace", ->
        atom.commands.dispatch(workspace, "find-and-replace:show-replace")
        expect(MinimapFindAndReplace.discoverMarkers.calls.length).toBe(1)

      it "should display markers on find-and-replace:toggle", ->
        atom.commands.dispatch(workspace, "find-and-replace:toggle")
        expect(MinimapFindAndReplace.discoverMarkers.calls.length).toBe(1)
