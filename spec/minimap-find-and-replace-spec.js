/** @babel */

const MinimapFindAndReplace = require('../lib/minimap-find-and-replace')

describe('MinimapFindAndReplace', () => {
	let workspace

	beforeEach(async () => {
		workspace = atom.views.getView(atom.workspace)
		jasmine.attachToDOM(workspace)

		// Package activation will be deferred to the configured, activation hook, which is then triggered
		// Activate activation hook
		atom.packages.triggerDeferredActivationHooks()
		atom.packages.triggerActivationHook('core:loaded-shell-environment')
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
				spyOn(MinimapFindAndReplace, 'changeVisible')
			})

			it('should clear on core:cancel', () => {
				atom.commands.dispatch(workspace, 'core:cancel')
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledTimes(1)
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledWith(false)
			})

			it('should clear on find-and-replace:toggle', () => {
				atom.commands.dispatch(workspace, 'find-and-replace:toggle')
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledTimes(1)
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledWith(false)
			})

			it('should clear on close button pressed', () => {
				document.querySelector('.find-and-replace .close-button').click()
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledTimes(1)
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledWith(false)
			})
		})

		describe('when find-and-replace is opened', () => {
			beforeEach(() => {
				atom.commands.dispatch(workspace, 'core:cancel')
				spyOn(MinimapFindAndReplace, 'changeVisible')
			})

			it('should display markers on find-and-replace:show', () => {
				atom.commands.dispatch(workspace, 'find-and-replace:show')
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledTimes(1)
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledWith(true)
			})

			it('should display markers on find-and-replace:show-replace', () => {
				atom.commands.dispatch(workspace, 'find-and-replace:show-replace')
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledTimes(1)
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledWith(true)
			})

			it('should display markers on find-and-replace:toggle', () => {
				atom.commands.dispatch(workspace, 'find-and-replace:toggle')
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledTimes(1)
				expect(MinimapFindAndReplace.changeVisible).toHaveBeenCalledWith(true)
			})
		})
	})
})
