# @author Torstein Thune
# @copyright 2016 Microbrew.it
angular.module('Microbrewit').factory('mbit/recipe/utility', [
	() ->
		# Update stepnumbers
		updateStepNumbers = (recipe) ->
			for i in [0...recipe.steps.length]
				recipe.steps[i].stepNumber = i + 1

			return recipe

		return {
			updateStepNumbers: updateStepNumbers
		}
])