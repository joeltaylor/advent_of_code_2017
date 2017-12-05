require 'minitest/autorun'
################################################################################
# Part 1
#
# Task
# Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while spiraling outward. For example, the first few squares are allocated like this:
#
# 17  16  15  14 13
# 18  5   4   3  12
# 19  6   1   2  11
# 20  7   8   9  10
# 21  22  23  24 25
#
# While this is very space-efficient (no squares are skipped), requested data must be carried back to square 1 (the location of the only access port for this memory system) by programs that can only move up, down, left, or right. They always take the shortest path: the Manhattan Distance between the location of the data and square 1.
# For example:
# Data from square 1 is carried 0 steps, since it's at the access port.
# Data from square 12 is carried 3 steps, such as: down, left, left.
# Data from square 23 is carried only 2 steps: up twice.
# Data from square 1024 must be carried 31 steps.
#
# How many steps are required to carry the data from the square identified in
# your puzzle input all the way to the access port?
# Your puzzle input is 347991.
#
# Input: Integer
# Output: Integer
#
################################################################################

def determine_distance(start_point)
  start_multiple = 3

  until start_point <= start_multiple ** 2
    start_multiple += 2
  end

  max_distance = start_multiple - 1
  base = start_multiple ** 2

  four_corners = [
    base,
    base - max_distance,
    base - max_distance * 2,
    base - max_distance * 3,
  ]

  four_corners.map! { |c| (c - start_point).abs }

  max_distance - corners.min
end

class StepFinderTest < Minitest::Test
  def test_example_case
    assert_equal(0, determine_distance(1))
    assert_equal(1, determine_distance(2))
    assert_equal(2, determine_distance(3))
    assert_equal(1, determine_distance(4))
    assert_equal(2, determine_distance(5))
    assert_equal(1, determine_distance(6))
    assert_equal(2, determine_distance(7))
    assert_equal(1, determine_distance(8))
    assert_equal(2, determine_distance(9))
    assert_equal(3, determine_distance(12))
    assert_equal(2, determine_distance(23))
    assert_equal(31, determine_distance(1024))
  end
end
