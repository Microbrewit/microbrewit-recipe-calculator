#
# Keeps track of a step model
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
angular.module('Microbrewit').directive('mbStep', [
	() ->
		link = (scope, element, attrs, controller, transcludeFn) ->

			# Set the type of the step
			# @param [String] type Type of step, valid values are ['mash', 'boil', 'sparge', 'fermentation']
			scope.setStepType = (type) ->
				switch type
					when 'mash'
						step = scope.step
						step.type = 'mash'
						step.volume = scope.recipe.mashVolume
						step.length = 0
						step.temperature = 55

					when 'boil'
						step = scope.step
						step.type = 'boil'
						step.volume = scope.recipe.preBoilVolume
						step.length = 0

					when 'sparge'
						step = scope.step
						step.type = 'sparge'
						step.amount = 0
						step.temperature = 55

					when 'fermentation'
						step = scope.step
						step.type = 'fermentation'
						step.volume = scope.recipe.volume
						step.length = 14
						step.temperature = 20

			# Add an ingredient to the step
			scope.addIngredient = ->
				scope.step.ingredients ?= []
				scope.step.ingredients.push({})

			# Remove an ingredient from the step
			# @param [IngredientObject] ingredient
			scope.removeIngredient = (ingredient) ->
				index = scope.step.ingredients.indexOf(ingredient)

				if index isnt -1
					scope.step.ingredients.splice(index, 1)

		return {
			scope:
				'step': '='
				'remove': '=' 
				'recipe': '='
				'refresh': '='
				'settings': '='
			replace: true
			templateUrl: 'recipe/build/step/step.html'
			link: link
		}
])
