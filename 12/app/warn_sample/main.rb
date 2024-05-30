require_relative './lib'
puts "Warning[:deprecated]: #{Warning[:deprecated]}"
Sample.deprecated_method

puts "-----------------------------"

puts "Warning[:experimental]: #{Warning[:experimental]}"
Sample.experimental_method

