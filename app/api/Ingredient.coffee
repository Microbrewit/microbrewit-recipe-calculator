# mbit/api/Ingredient
#
# REST ($http) wrapper for ingredient endpoints
#
# Depends on: ['mbit/api/Request']
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
angular.module('Microbrewit').factory('mbit/api/Ingredient', [
	'mbit/api/Request'
	(Request) ->

		endpoint = 'json'

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		getFermentables = (id = '') ->
			return Request.get "/#{endpoint}/fermentables/#{id}"

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		getHops = (id = '') ->
			return Request.get "/#{endpoint}/hops/#{id}"

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		getYeasts = (id = '') ->
			return Request.get "/#{endpoint}/yeasts/#{id}"

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		getOthers = (id = '') ->
			return Request.get "/#{endpoint}/others/#{id}"

		getIngredients = (id = '') ->
			return Request.get "/#{endpoint}/ingredients/#{id}"

		return {
			getFermentables, getHops, getYeasts, getOthers, getIngredients
		}
])