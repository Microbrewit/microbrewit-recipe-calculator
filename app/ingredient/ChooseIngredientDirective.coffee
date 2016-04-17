#
# Directive for finding and choosing an ingredient
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
angular.module('Microbrewit').directive('mbChooseIngredient', [
	'mbit/api/Ingredient' # To fetch ingredients from API
	'$document' # To register event listener
	(Ingredients, $document) ->
		ESC_KEY_CODE = 27

		link = (scope, element, attrs, controller, transcludeFn) ->

			ingredients = []
			setIngredientCallback = null
			scope.visible = false
			scope.filterText = ''
			scope.ingredients = []
			scope.typeFilters =
				fermentable: true
				hop: true
				yeast: true
				other: true


			open = ->
				scope.visible = true
				$document.on 'keydown', (e) ->
					if e.keyCode is ESC_KEY_CODE
						close()
						scope.$apply()

			close = ->
				$document.off 'keydown'
				scope.visible = false
				scope.filterText = ''
				scope.typeFilters =
					fermentable: true
					hop: true
					yeast: true
					other: true

			scope.close = ->
				close()

			scope.setIngredient = (ingredient) ->
				setIngredientCallback ingredient
				close()

			getIngredientsFromCache = ->
				ingredients = JSON.parse(localStorage.ingredients)
				return ingredients

			checkCacheValid = ->
				lastUpdated = parseInt localStorage.lastUpdated
				return lastUpdated? and lastUpdated > (new Date().getTime() - 1000 * 60 * 60 * 24)

			# Check cache and/or get from api
			getAllIngredients = (cb) ->
				if checkCacheValid()
					cb(getIngredientsFromCache())

				else
					localStorage.lastUpdated = new Date().getTime()
					Ingredients.getIngredients().then (data) ->
						# Set a searchstring for quicker filtering later
						data.map (ingredient) -> ingredient.searchString = "#{ingredient.name} #{ingredient.productCode}".toLowerCase()
						localStorage.ingredients = JSON.stringify _.sortBy(data, ['name'])
						cb(getIngredientsFromCache())

			# Filter ingredients when searching
			filterIngredients = (ingredient, filterText, typeFilters) ->
				if typeFilters[ingredient.type] is false
					return false
				return true if filterText is ''
				return ingredient.searchString.indexOf(filterText) isnt -1

			# Get all ingredients
			getAllIngredients (ingredients) ->
				scope.ingredients = ingredients
				ingredients = ingredients

			# Setup watchers
			scope.$watch '[filterText, typeFilters.fermentable, typeFilters.hop, typeFilters.yeast, typeFilters.other]', (newValue) ->
				scope.ingredients.map (ingredient) ->
					ingredient.show = filterIngredients(ingredient, scope.filterText, scope.typeFilters)

			# This is how we open the picker from a directive
			scope.$on 'openIngredientPicker', (event, callback) ->
				setIngredientCallback = callback
				open()
			
		return {
			replace: true
			templateUrl: 'recipe/build/ingredient/ingredient-chooser.html'
			link: link
		}
])
