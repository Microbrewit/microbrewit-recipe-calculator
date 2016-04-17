angular.module('Microbrewit').value 'mbit/recipe/BaseModel',
	name: ''
	beerStyle:
		id: 0
		name: ''

	forkOf: undefined
	forkOfId: undefined

	brewers: []
	breweries: []

	abv: 
		standard: 0
		miller: 0
		advanced: 0
		advancedAlternative: 0
		simple: 0
		alternativeSimple: 0

	colour:
		standard: 0
		mosher: 0
		daniels: 0
		morey: 0

	bitterness: 
		standard: 0
		tinseth: 0
		rager: 0

	recipe:
		notes: ''
		og: 0
		fg: 0
		efficiency: 70
		volume: 30
		steps: [
			{
				stepNumber: 1
				type: 'mash'
				length: 15
				ingredients: []
			}
		]