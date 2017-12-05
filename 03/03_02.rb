require 'minitest/autorun'
require 'pry'
################################################################################
# Part 2
#
# Task
# As a stress test on the system, the programs here clear the grid and then
# store the value 1 in square 1. Then, in the same allocation order as shown
# above, they store the sum of the values in all adjacent squares, including
# diagonals.

# So, the first few squares' values are chosen as follows:

# Square 1 starts with the value 1.
# Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
# Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
# Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
# Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.
# Once a square is written, its value does not change. Therefore, the first few squares would receive the following values:

# 147  142  133  122   59
# 304    5    4    2   57
# 330   10    1    1   54
# 351   11   23   25   26
# 362  747  806--->   ...
# What is the first value written that is larger than your puzzle input?

# Your puzzle input is still 347991.
################################################################################
class Spiral
  NEIGHBORS = [
    [-1, 1],  [0,1],  [1,1],
    [-1, 0],          [1,0],
    [-1, -1], [0,-1], [1,-1],
  ].freeze

  def initialize
    @coordinates = [0, 0]
    @value_store = Hash.new {|h,k| h[k] = 0}
    @value_store["[0, 0]"] =  1
  end

  def larger_than(target)
    @target = target
    @max_value = 1

    return @coordinates if target == @value

    while true do
      until @coordinates[0] == @max_value do
        @coordinates[0] += 1
        store_value
        return @current_value if @current_value > @target
      end

      until @coordinates[1] == @max_value do
        @coordinates[1] += 1
        store_value
        return @current_value if @current_value > @target
      end

      until @coordinates[0] == -@max_value do
        @coordinates[0] += -1
        store_value
        return @current_value if @current_value > @target
      end

      until @coordinates[1] == -@max_value do
        @coordinates[1] += -1
        store_value
        return @current_value if @current_value > @target
      end

      @max_value += 1
    end
    @coordinates
  end

  def store_value
    x, y = @coordinates
    current_neighbors = NEIGHBORS.map {|n| [n[0] + x, n[1] + y]}.map(&:to_s)
    @current_value = current_neighbors.inject(0) { |sum, n| sum += @value_store[n] }
    @value_store[@coordinates.to_s] = @current_value
  end
end

class SpiralTest < Minitest::Test
  def test_larger_than
    assert_equal(4, Spiral.new.larger_than(2))
    assert_equal(806, Spiral.new.larger_than(747))
  end
end

puts "#"*100
puts  Spiral.new.larger_than(347991)
puts "#"*100
