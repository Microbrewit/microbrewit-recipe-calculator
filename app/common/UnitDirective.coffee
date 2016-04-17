#
# Directive for displaying things in correct units.
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
angular.module('Microbrewit').directive('mbUnit', [
	() ->
		link = (scope, element, attrs, controller, transcludeFn) ->

			updateLocalValue = ->
				scope.localvalue = mbFormulas.convert.convert(scope.value, attrs.modelunit, scope.localunit)

			updateModelValue = ->
				scope.value = mbFormulas.convert.convert(scope.localvalue, scope.localunit, attrs.modelunit)

			updateLocalValue()
			updateModelValue()

			# # modelunit will never change (it will always be the same as the server)
			scope.$watch(->
				return [scope.localunit, attrs.value]
			, updateLocalValue, true)

			scope.$watch(->
				return [scope.localvalue]
			, updateModelValue, true)


		return {

			scope:
				'value': '='
				'localunit': '@'

			replace: true
			template: '
				<span class="no-wrap">
					<input type="number" ng-model="localvalue"/> {{localunit}}
				</span>
			'
			link: link
		}
])
	