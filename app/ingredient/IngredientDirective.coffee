mbit = angular.module('Microbrewit')

# Keeps track of an ingredient model
# @author Torstein Thune
# @copyright 2016 Microbrew.it
mbit.directive('mbIngredient', [
	'mbit/services/RecipeUtilityService'
	'$rootScope'
	(Utils, $rootScope) ->
		link = (scope, element, attrs, controller, transcludeFn) ->

			mergeIngredient = (oldIngredient, model) ->

				console.log model

				ingredient = 
					amount: oldIngredient.amount

				ingredient.amount ?= 0

				for key, val of model
					console.log key

					if key is '$$hashKey'
						#do nothing

					# else if key is 'dataType'
					# 	ingredient.type = val

					# else if key is 'type'
					# 	ingredient.subType = val
					else
						ingredient[key] = val

				return ingredient

			setIngredient = (ingredient) ->
				newIngredient = mergeIngredient(scope.ingredient, ingredient)

				for key, val of newIngredient
					scope.ingredient[key] = val

			scope.openIngredientPicker = ->
				console.log 'openIngredientPicker'
				$rootScope.$broadcast 'openIngredientPicker', setIngredient

			refreshValues = (ingredient) ->
				switch ingredient.type
					when 'fermentable'
						ingredient.calculated = Utils.calcFermentableValues(ingredient, scope.recipe)

						scope.refresh ['srm', 'og', 'fg', 'abv']

						console.log 'fermentable', ingredient

					when 'hop'
						ingredient.calculated = Utils.calcHopValues(ingredient, scope.step, scope.recipe)

						scope.refresh ['ibu']

						console.log 'hop', ingredient

			scope.$watch 'ingredient', (newValue, oldValue) ->
				console.log 'ingredient changed'
				refreshValues(newValue)

			scope.$watch 'ingredient.amount', () -> refreshValues(scope.ingredient)
			scope.$watch 'ingredient.aaValue', () -> refreshValues(scope.ingredient)

			scope.$watch 'recipe.efficiency', () -> refreshValues(scope.ingredient)
			scope.$watch 'recipe.volume', () -> refreshValues(scope.ingredient)

				

		return {
			scope:
				'ingredient': '='
				'remove': '='
				'recipe': '='
				'step': '='
				'refresh': '='
				'settings': '='
			replace: true
			templateUrl: 'recipe/build/ingredient/ingredient.html'
			link: link
		}
])



