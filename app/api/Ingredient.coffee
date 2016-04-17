mbit = angular.module('Microbrewit')

# mbit/api/Ingredient
#
# REST ($http) wrapper for ingredient endpoint
#
# Contains one factory with four methods:
# - Ingredient.getFermentables
# - Ingredient.getHops
# - Ingredient.getYeasts
# - Ingredient.getOthers
#
# Depends on: ['mbit/api/Request']
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
mbit.factory('mbit/api/Ingredient', [
	'mbit/api/Request'
	(Request) ->

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		getFermentables = (id = '') ->
			return Request.get "/json/fermentables/#{id}"

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		getHops = (id = '') ->
			return Request.get "/json/hops/#{id}"

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		getYeasts = (id = '') ->
			return Request.get "/json/yeasts/#{id}"

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		getOthers = (id = '') ->
			return Request.get "/json/others/#{id}"

		getIngredients = (id = '') ->
			return Request.get "/json/ingredients/#{id}"

		return {
			getFermentables, getHops, getYeasts, getOthers, getIngredients
		}
])