# mbit/api/Request
#
# REST ($http) wrapper
#
# Depends on: ['$http', 'ApiUrl', 'ClientUrl']
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
angular.module('Microbrewit').factory('mbit/api/Request', [
	'$http'
	($http) ->

		# GET: $http.jsonp wrapper
		# We are talking to the middleware-server so no tokens needed.
		# @param [Object] options
		get = (requestUrl, options = {}) ->
			if requestUrl.indexOf('?') is -1
				requestUrl += '?callback=JSON_CALLBACK'
			else
				requestUrl += '&callback=JSON_CALLBACK'

			console.log "GET: #{requestUrl}"

			# Create promise
			promise = $http.get(requestUrl, {})
				.error((data, status, headers) ->
					console.error "GET #{requestUrl} gave HTTP #{status}", data
					return {
						data: data
						status: status
						headers: headers
					}
				)
				.then((response) ->
					returnData = response.data
					if options.returnProperty? and response.data[options.returnProperty]?
						returnData = response.data[options.returnProperty]
					return returnData
				)

			return promise

		# POST: $http.post wrapper
		# We are talking to the middleware-server so no tokens needed.
		# @param [String] requestUrl The endpoint to POST to
		# @param [Object] payload The data structure to POST to server
		# @return [Promise] promise
		post = (requestUrl, payload) ->
			options = {}

			console.log "POST: #{requestUrl}"

			promise = $http.post(requestUrl, payload, options)
				.error((data, status, headers) ->
					console.error "POST #{requestUrl} gave HTTP #{status}", data
					return {
						data: data
						status: status
						headers: headers
					}
				)
				.then((response) ->
					return response.data
				)
			
			return promise

		# POST: $http.put wrapper
		# We are talking to the middleware-server so no tokens needed.
		# @param [String] requestUrl The endpoint to PUT to
		# @param [Object] payload The data structure to PUT to server
		# @return [Promise] promise
		put = (requestUrl, payload) ->
			options = {}

			console.log "PUT: #{requestUrl}"

			promise = $http.put(requestUrl, payload, options)
				.error((data, status, headers) ->
					console.error "PUT #{requestUrl} gave HTTP #{status}", data
					return {
						data: data
						status: status
						headers: headers
					}
				)
				.then((response) ->
					return response.data
				)
			
			return promise

		return {
			get: get
			post: post
			put: put
		}
])