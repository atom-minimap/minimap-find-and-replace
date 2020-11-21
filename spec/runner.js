const { createRunner } = require('atom-jasmine3-test-runner')

module.exports = createRunner({
	specHelper: {
		attachToDom: true,
	},
	testPackages: ['minimap'],
})
