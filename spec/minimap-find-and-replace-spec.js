/** @babel */

const MinimapFindAndReplace = require('../lib/minimap-find-and-replace')

describe('MinimapFindAndReplace', () => {
	let workspace

	beforeEach(async () => {
		workspace = atom.views.getView(atom.workspace)
		jasmine.attachToDOM(workspace)

		await atom.packages.activatePackage('minimap')

		const promise = atom.packages.activatePackage('find-and-replace')
		atom.commands.dispatch(workspace, 'find-and-replace:show')
		await promise
	})

	describe('when the package is activated', () => {
		beforeEach(async () => {
			await atom.packages.activatePackage('minimap-find-and-replace')
		})

		it('should activate', () => {
			expect(MinimapFindAndReplace.isActive()).toBe(true)
		})

		describe('when find-and-replace is closed', () => {
			beforeEach(() => {
				atom.commands.dispatch(workspace, 'find-and-replace:show')
				spyOn(MinimapFindAndReplace, 'clearBindings')
			})

			it('should clear on core:cancel', () => {
				atom.commands.dispatch(workspace, 'core:cancel')
				expect(MinimapFindAndReplace.clearBindings).toHaveBeenCalledTimes(1)
			})

			it('should clear on find-and-replace:toggle', () => {
				atom.commands.dispatch(workspace, 'find-and-replace:toggle')
				atom.commands.dispatch(workspace, 'find-and-replace:toggle')
				expect(MinimapFindAndReplace.clearBindings).toHaveBeenCalledTimes(1)
			})

			it('should clear on close button pressed', () => {
				document.querySelector('.find-and-replace .close-button').click()
				expect(MinimapFindAndReplace.clearBindings).toHaveBeenCalledTimes(1)
			})
		})

		describe('when find-and-replace is opened', () => {
			beforeEach(() => {
				atom.commands.dispatch(workspace, 'core:cancel')
				spyOn(MinimapFindAndReplace, 'discoverMarkers')
			})

			it('should display markers on find-and-replace:show', () => {
				atom.commands.dispatch(workspace, 'find-and-replace:show')
				expect(MinimapFindAndReplace.discoverMarkers).toHaveBeenCalledTimes(1)
			})

			it('should display markers on find-and-replace:show-replace', () => {
				atom.commands.dispatch(workspace, 'find-and-replace:show-replace')
				expect(MinimapFindAndReplace.discoverMarkers).toHaveBeenCalledTimes(1)
			})

			it('should display markers on find-and-replace:toggle', () => {
				atom.commands.dispatch(workspace, 'find-and-replace:toggle')
				expect(MinimapFindAndReplace.discoverMarkers).toHaveBeenCalledTimes(1)
			})
		})
	})
})
