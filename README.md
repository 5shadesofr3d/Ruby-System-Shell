# Ruby System Shell

A ruby application which mimic's the linux command line shell

# Ruby Style Guide

Please follow this style guide when writing your code:

```
# filenames should be all lower case with underscores representing spaces
# eg. quick_style_guide.rb

require 'test/unit'
require '<put gems here>'
require_relative '<put custom ruby files here>'

module ModuleNamesUseUpperLower

end

class ClassNamesUseUpperLower
	# Describe class with comment here
	include Test::Unit::Assertions

	@class_attribute = true
	@@static_class_attribute = false

	attr_reader :class_attribute2 # ruby will automatically create a getter method
	attr_writer :class_attribute3 # ruby will automatically create a setter method
	attr_accessor :class_attribute4 # ruby will automatically create a getter and setter method

	def valid?
		# class invariant here (must return a boolean value)
		return false unless @class_attribute2.is_a? Integer
		return false unless @class_attribute3.is_a? String
		return false unless @class_attribute4.is_a? Array

		return true
	end

	def initialize()
		# class constructor here
		@class_attribute2 = 1
		@class_attribute3 = "1"
		@class_attribute4 = [1]

		assert valid?
	end

	def function_names_use_underscores(param_one, param_two)
		# function description here
		assert valid?

		assert precondition1
		assert precondition2

		# function body here
		var_name = 'some value'

		assert postcondition1
		assert postcondition2

		assert valid?

		return result # if any
	end

	def function_that_returns_bool?()
		# eg. use a '?' in the method name
		assert valid?
			...
		assert valid?
		return @class_attribute
	end

	def function_that_modifies_class!()
		# eg. use a '!' in the method name (normally we do not return a value)
		assert valid?
			...
		@class_attribute = false
			...
		assert valid?
	end
end
```
