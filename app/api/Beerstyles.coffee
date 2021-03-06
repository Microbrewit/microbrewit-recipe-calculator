mbit = angular.module('Microbrewit')
#
# Depends on: ['mbit/api/Request']
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
mbit.factory('mbit/api/Beerstyles', [
	'mbit/api/Request'
	(Request) ->

		endpoint = 'json/beerStyles'

		# @param [Integer] id (optional) If you want to get a single one
		# @return [Promise] promise
		get = (id = '') ->
			return Request.get "/#{endpoint}/#{id}"

		return { get }
])