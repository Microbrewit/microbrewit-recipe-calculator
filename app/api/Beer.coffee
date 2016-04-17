mbit = angular.module('Microbrewit')

# mbit/api/Beer
#
# REST ($http) wrapper for beer endpoint
#
# Contains one factory with three methods:
# - Beer.get
# - Beer.add
# - Beer.update
#
# Depends on: ['mbit/api/Request']
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
mbit.factory('mbit/api/Beer', [
	'mbit/api/Request'
	(Request) ->
		endpoint = 'json/beers'

		# @param [Integer] id The id of the beer to get
		# @return [Promise] promise
		get = (id) ->
			return Request.get "/#{endpoint}/#{id}"

		# @param [Object<Beer>] beer The beer to add
		# @return [Promise] promise
		add = (beer) ->
			return Request.post "/#{endpoint}", beer

		# @param [Object<Beer>] beer The beer to update
		# @return [Promise] promise
		update = (beer) ->
			return Request.put "/#{endpoint}/#{beer.id}", beer

		return {
			get: get
			add: add
			update: update
		}
])