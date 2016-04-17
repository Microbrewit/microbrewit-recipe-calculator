#
# Keeps track of the Recipe model
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
angular.module('Microbrewit').controller('RecipeController', [
	'mbit/api/Beer'
	'mbit/api/Ingredient'
	'mbit/api/Beerstyles'
	'$scope'
	'mbit/recipe/utility'
	'mbit/recipe/BaseModel'
	'mbit/services/RecipeUtilityService'
	'$stateParams'
	(Beer, Ingredient, Beerstyles, $scope, Utility, BaseModel, Utils, $stateParams) ->

		getBeerStyles = ->
			Beerstyles.get().then (data) ->
				console.log data

		getBeerStyles()

		# Get recipe if we are editing/forking
		# @todo
		getRecipe = (id) ->
			Beer.get(id).then((data) ->
				console.log data.beers[0]
				$scope.beer = data.beers[0])

		# createIngredientCache()
		console.log 'stateParams:', $stateParams

		if $stateParams.id
			getRecipe($stateParams.id)
		else if typeof recipe is 'object'
			console.log recipe
			$scope.beer = recipe.beers[0] # recipe is injected into the DOM by the ImportHandler
		else
			$scope.beer = BaseModel



		$scope.mode = "#{$stateParams.mode}ing" if $stateParams.mode

		# Metadata that is calculated but not a part of the beer/recipe model
		$scope.meta =
			boilVolume: 0
			mcu: 0

		$scope.setMeasures = (type) ->
			$scope.settings = Utils.getMeasureSettings(type)
			console.log $scope.settings

		$scope.settings = Utils.getMeasureSettings('metric')

		$scope.refresh = (things) ->
			console.log "Refresh #{JSON.stringify(things)}"

			beer = $scope.beer
			recipe = $scope.beer.recipe

			for thing in things
				switch thing
					when 'srm'
						beer.srm = Utils.calcSrm(recipe)

					when 'ibu'
						beer.ibu = Utils.calcIbu(recipe)

					when 'og'
						recipe.og = Utils.calcOG(recipe)

					when 'fg'
						recipe.fg = Utils.calcFG(recipe)

					when 'abv'
						beer.abv = Utils.calcAbv(recipe)

		# Moves a step in the recipe.steps array
		# @param [Object] step The step to move
		# @param [Integer] toIndex The index to move to
		# @note The toIndex is the index before the move
		$scope.moveStep = (step, toIndex) ->
			index = $scope.beer.recipe.steps.indexOf(step)
			
			if index isnt -1
				# The index of the element will change once
				# we re-add it to the new location if we add
				# it before the previous location
				index++ if toIndex < index

				# Add to new location
				$scope.beer.recipe.steps.splice(toIndex, 0, step)

				# Remove from old location
				$scope.beer.recipe.steps.splice(index, 1)

				$scope.beer.recipe = Utility.updateStepNumbers($scope.beer.recipe)

		# Add a step to the recipe
		$scope.addStep = (step) ->
			recipe = $scope.beer.recipe
			index = recipe.steps.indexOf(step)

			availableTypes = Utils.getValidStepTypes(recipe, null, recipe.steps.length)

			$scope.beer.recipe.steps.splice(index + 1, 0, {availableTypes})

			$scope.beer.recipe = Utility.updateStepNumbers($scope.beer.recipe)

		# Remove a step from the recipe
		# @param [StepObject] step
		$scope.removeStep = (step) ->
			index = $scope.beer.recipe.steps.indexOf(step)
			$scope.beer.recipe.steps.splice(index, 1) if index isnt -1
			$scope.beer.recipe = Utility.updateStepNumbers($scope.beer.recipe)

		# Send the full beer object back to the API
		# @todo
		$scope.save = ->
])
