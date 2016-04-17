# Microbrew.it recipe editor
# @author Torstein Thune
# @copyright 2016 Microbrew.it
mbit = angular.module('Microbrewit',
	[
		'ui.router'
	]
)

mbit.config ($stateProvider, $urlRouterProvider, $locationProvider) ->
	
	#For any unmatched url, redirect to /state1
	$urlRouterProvider.otherwise '/'

	$locationProvider.html5Mode true

	# Catches fork/edit
	$stateProvider
	.state 'other', {
		url: '/beers/{id:int}/{mode}'
		templateUrl: 'recipe/build/recipe/recipe.html'
		controller: 'RecipeController'
	}
	# Catches add
	.state 'add', {
		url: '/beers/add'
		templateUrl: 'recipe/build/recipe/recipe.html'
		controller: 'RecipeController'
	}
	# Catches import
	.state 'import', {
		url: '/beers/import'
		mode: 'import'
		templateUrl: 'recipe/build/recipe/recipe.html'
		controller: 'RecipeController'
	}
