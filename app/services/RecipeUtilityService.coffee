#
# Utility functions for recipes
#
# @author Torstein Thune
# @copyright 2016 Microbrew.it
angular.module('Microbrewit').factory('mbit/services/RecipeUtilityService', [
	() ->

		# Get previous step with type in recipe
		# @note recursive
		# @return [Step, undefined]
		_getStepBefore = (recipe, index) ->
			if index is 0
				return undefined

			stepBefore = recipe.steps[index - 1]

			if stepBefore.type
				return stepBefore
			else
				return _getStepBefore(recipe, index - 1)

		# Get valid step types
		# @return [Array<String>]
		getValidStepTypes = (recipe, step, index) ->
			index ?= recipe.steps.indexOf(step)

			stepBefore = _getStepBefore(recipe, index)

			unless stepBefore
				return ['mash']

			switch stepBefore.type
				when 'mash'
					return ['mash', 'sparge', 'boil']
				when 'sparge'
					return ['boil']
				when 'boil'
					return ['boil', 'fermentation']
				when 'fermentation'
					return ['fermentation']

		getMeasureSettings = (type) ->
			switch type
				when 'imperial'
					return {
						liquid: 
							unit: 'oz'
						fermentable:
							unit: 'lbs'
						hop:
							unit: 'lbs'
						other:
							unit: 'lbs'
						yeast:
							unit: 'lbs'
					}
				when 'metric'
					return {
						liquid:
							unit: 'liters'
						fermentable:
							unit: 'grams'
						hop:
							unit: 'grams'
						other:
							unit: 'grams'
						yeast:
							unit: 'grams'
					}

		getRandomArbitrary = (min, max) ->
			return Math.random() * (max - min) + min

		calcFermentableValues = (fermentable, recipe) ->
			mcu = mbFormulas.colour.mcu(mbFormulas.convert.convert(fermentable.amount, 'grams', 'kg'), fermentable.lovibond, recipe.volume)
			console.log fermentable
			
			srm = {}
			for formula in mbFormulas.colour.available()
				if formula isnt 'mcu'
					srm[formula] = mbFormulas.colour[formula]({mcu})

			srm.standard = srm.morey

			gp = mbFormulas.gravity.gravityPoints
				type: fermentable.subType
				efficiency: recipe.efficiency
				amount: fermentable.amount
				volume: recipe.volume
				ppg: fermentable.ppg

			rgb = mbFormulas.convert.convert fermentable.lovibond, 'lovibond', 'rgb'

			return {
				mcu, srm, gp, rgb
			}

		calcHopValues = (hop, step, recipe) ->
			calcObj =
				boilGravity: recipe.og
				utilisation: step.length
				boilVolume: step.volume
				aa: hop.aaValue
				amount: hop.amount
				boilTime: step.length

			# @todo remove once steps are properly reimplemented
			calcObj.boilVolume = recipe.volume if calcObj.boilVolume is 0

			calculated = 
				bitterness: {}

			for formula in mbFormulas.bitterness.available()
				calculated.bitterness[formula] = mbFormulas.bitterness[formula](calcObj)

			return calculated

		calcYeastValues = (yeast, step, recipe) ->
			return {}

		# Calculate OG for a recipe
		# @param [Recipe] recipe
		# @return [Float] OG
		calcOG = (recipe) ->
			totalGP = 0
			for step in recipe.steps
				for ingredient in step.ingredients
					if ingredient.type is 'fermentable'
						totalGP += ingredient.calculated.gp

			return mbFormulas.gravity.og(totalGP)

		# Calculate FG for a recipe
		# @param [Recipe] recipe
		# @return [Float fg]
		# @todo Send in Yeast attenuation to get more exact result
		calcFG = (recipe) ->
			return mbFormulas.gravity.fg(recipe.og)

		calcAbv = (recipe) ->
			abv = {}
			for formula in mbFormulas.abv.available()
				console.log formula
				abv[formula] = mbFormulas.abv[formula]?(recipe.og, recipe.fg)

			abv.standard = abv.microbrewit
			return abv

		# Calculate the IBU value for the recipe
		# i.e gather all the IBU values from hops
		# @param [Recipe] recipe
		# @return [Object] ibu All the different formulas
		calcIbu = (recipe) ->
			ibu = {}
			for step in recipe.steps
				for ingredient in step.ingredients
					if ingredient.type is 'hop'
						for key, val of ingredient.calculated?.bitterness
							unless ibu[key]
								ibu[key] = val.ibu
							else
								ibu[key] += val.ibu

			ibu.standard = ibu.tinseth
			return ibu

		# Calculate the SRM value for the recipe
		# i.e gather all MCU values and use formulas to calculate
		# @param [Recipe] recipe
		# @return [Object] srm
		calcSrm = (recipe) ->
			mcu = 0
			for step in recipe.steps
				for ingredient in step.ingredients
					if ingredient.type is 'fermentable'
						mcu += ingredient.calculated.mcu

			srm = {}
			for formula in mbFormulas.colour.available()
				if formula isnt 'mcu'
					srm[formula] = mbFormulas.colour[formula]({mcu})

			srm.standard = srm.morey

			return srm

		return {
			calcOG, calcFG, calcSrm, calcIbu, calcAbv, calcFermentableValues, calcHopValues, getMeasureSettings, getValidStepTypes
		}
])
