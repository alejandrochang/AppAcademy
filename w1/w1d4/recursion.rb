# recursion.rb

# Write a recursive method, range, that takes a start and an end and returns an
# array of all numbers between.

def range(start_range, end_range)
  return [start_range] if start_range == end_range

  range(start_range, end_range - 1 ) << end_range
end

################################################################

# Write both a recursive and iterative version of sum of an array.

class Array

  #recursion
  def recursion_sum
    return 0 if self.empty?
    self[0] + self[1..-1].recursion_sum
  end

  #iterative
  def iterative_sum
    self.inject(:+)
  end
end


################################################################

# Exponentiation
#
# Write two versions of exponent that use two different recursions:
#
# # this is math, not Ruby methods.
#
# # recursion 1
# exp(b, 0) = 1
# exp(b, n) = b * exp(b, n - 1)
#
# # recursion 2
# exp(b, 0) = 1
# exp(b, n) = exp(b, n / 2) ** 2             [for even n]
# exp(b, n) = b * (exp(b, (n - 1) / 2) ** 2) [for odd n]
# Note that for recursion 2, you will need to square the results of exp(b, n / 2)
# and (exp(b, (n - 1) / 2). Remember that you don't need to do anything special
# to square a number, just calculate the value and multiply it by itself.
#
# If the n == 256, about how many nested recursive steps will we run in the
# first case?
#
# How deep will we need to recurse for the second? Keep in mind that the first
# reduces the exponent by one for each recursion, while the second reduces it
# by half. Even if we don't recurse as deeply, do we call exp using recursion 2
# less often than using recursion 1?

# 256 loops for n == 256
def exp_first(value, power)
  power == 0 ? 1 : (value * exp_first(value, power - 1))
end

# 9 loops for n = 256
def exp_second(value, power)
  case power
  when 0
    return 1
  when 1
    return value
  else
    exp_second(value, (power/2).floor) * exp_second(value, (power/2).ceil)
  end  
end

# 2^3 => (3/2).floor = 1, (3/2).ceil = 2; 2^1 * 2^2 == 2^3


################################################################

# The #dup method doesn't make a deep copy:
#
# robot_parts = [
#   ["nuts", "bolts", "washers"],
#   ["capacitors", "resistors", "inductors"]
# ]
#
# robot_parts_copy = robot_parts.dup
#
# # shouldn't modify robot_parts
# robot_parts_copy[1] << "LEDs"
# # wtf?
# robot_parts[1] # => ["capacitors", "resistors", "inductors", "LEDs"]
# When we dup an Array, it creates a new array to hold the elements, but
# doesn't recursively dup any arrays contained therein. So the dup method
# creates one new array, but just copies over references to the original
# interior arrays.
#
# Using recursion and the is_a? method, write a new deep_dup method that will
# perform a "deep" duplication of the interior arrays.
#
# You may use dup in your deep_dup method, but it shouldn't be strictly
# necessary. It's okay to iterate over array elements using each for this one.
#
# You should be able to handle "mixed" arrays like [1, [2], [3, [4]]].

# class Array
#   def deep_dup
#     [].tap do |dup|
#       self.each do |el|
#         dup << (el.is_a?(Array) ? el.deep_dup : el)
#       end
#     end        
#   end
# end

# OR

class Array
  def deep_dup
    map { |el| el.is_a?(Array) ? el.deep_dup : el }
  end
end

################################################################

# Fibonacci
#
# Write a recursive and an iterative Fibonacci method. The method should take
# in an integer n and return the first n Fibonacci numbers in an array.
#
# You shouldn't have to pass any arrays between methods; you should be able to
# do this just passing a single argument for the number of Fibonacci numbers
# requested.

# iterative
def fib(num)
  return [] if num <= 0
  return [0] if num == 1

  results = [0, 1]

  until results.length == num
    results << results[-1] + results[-2]
  end
  results

end


# recursive
def fib_rec(num)
  return [] if num <= 0
  return [0] if num == 1
  return [0, 1] if num == 2

  fib_array = fib_rec(num - 1)
  fib_array << fib_array[-1] + fib_array[-2]

end

# Nicer structure

def fib_rec(num)
  return [] if num <= 0
  
  case num
  when 1
    return [0]
  when 2
    return [0, 1]
  else
    fibs = fibs_rec(n - 1)
    fibs << fibs[-2] + fibs[-1]
  end
  
end

################################################################
# Binary Search
#
# Write a recursive binary search: bsearch(array, target). Note that binary
# search only works on sorted arrays. Make sure to return the location of the
# found object (or nil if not found!). Hint: you will probably want to use
# subarrays.

# refactored version 2
def bsearch(array, target)
  return nil if array.length == 0
  
  midpoint = array.length / 2
  case target <=> array[midpoint]
  when -1
    bsearch(array.take(midpoint), target)
  when 0
    midpoint
  when 1
    index = bsearch(array.drop(midpoint + 1), target)
    (index.nil?) ? nil : (midpoint + 1) + index
  end
end

# version 1
# def bsearch(array, target)
#   return nil if array.empty?
#   return nil if array.length == 1 && array[0] != target
#   sorted_array = array.sort
#   arr_size = array.size
#   midpoint = arr_size / 2
#   puts midpoint
#   n = sorted_array[midpoint] <=> target
#   case n
#   when -1
#     # move right
#     subarray = sorted_array[(midpoint + 1)..-1]
#     index = bsearch(subarray, target)
#     return midpoint + index + 1 if index
#     return nil
#   when 1
#     # move left
#     subarray = sorted_array[0..(midpoint - 1)]
#     index = bsearch(subarray, target)
#     return index
#   else
#     puts 'found at #{midpoint}'
#     return midpoint
#   end
# end

################################################################

# Make Change
#
# RubyQuiz: Make change. Make sure your solution works not only for our normal
# currency, but wonky currencies like [10, 7, 1]. This means trying every
# combination of coins.

# WIP: all combinations
def make_change(amount, coins = [25, 10, 5, 1])
  return 0 if (coins.empty? || amount == 0)

  wonky_coins = coins

  sum = amount / wonky_coins[0]
  remainder = amount % wonky_coins[0]
  wonky_coins.shift

  total_change = sum + make_change(remainder, wonky_coins)

end


################################################################
# Merge Sort
# Implement a method, merge_sort that sorts an Array.
# Hint: The base case for this sort is surprisingly simple.
# You'll want to write a merge helper method to merge the sorted halves.

class Array
  def merge_sort
    return self if self.length <= 1
    to_sort = self
    midpoint = to_sort.length / 2

    array1, array2 = to_sort.take(midpoint), to_sort.drop(midpoint)
    merge(array1.merge_sort, array2.merge_sort)
  end

  def merge array1, array2
    sorted_array = []
    until (array1.empty? || array2.empty?)
      sorted_array << (array1.first < array2.first ? array1.shift : array2.shift)
    end
    
    sorted_array + array1 + array2      
  end
end


################################################################
# Write a method, subsets, that will return all subsets of an array.
# subsets([]) # => [[]]
# subsets([1]) # => [[], [1]]
# subsets([1, 2]) # => [[], [1], [2], [1, 2]]
# subsets([1, 2, 3])
# # => [[], [1], [2], [1, 2], [3], [1, 3], [2, 3], [1, 2, 3]]

def subsets array
  return [[]] if array.empty?
  
  small_subs = subsets(array.take(array.length - 1))
  supersize = small_subs.map { |sub| sub + [array.last] }
  small_subs + supersize
end