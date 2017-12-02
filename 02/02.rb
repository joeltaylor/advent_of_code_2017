require 'minitest/autorun'
require 'benchmark'
require 'csv'
################################################################################
# Part 1
#
# Task
# Given a spreadsheet, calculate the checksum. For each row, determine the
# difference between the largest and smallest value. The checksum is the
# sum of all of those differences.
#
# Example:
# 5 1 9 5
# 7 5 3
# 2 4 6 8
#
# - The first row's value is 8 (9 - 1)
# - The second row's value is 4 (7 - 3)
# - The third row's value is 6 (8 - 2)
# -  In this example, the spreadsheet's checksum would be 8 + 4 + 6 = 18.
#
# Input: TSV file
# Output: Integer
#
# Current solution:
# Time complexity: O(n)
# Space complexity: O(n)
#
# Part 2
#
# Task
# This time the checksum is found by finding the only two numbers that divide
# evenly, where the result of the division is a whole number
#
# Example:
# 5 9 2 8
# 9 4 7 3
# 3 8 6 5
#
# 9 7 4 3 2
# 9 8 5 2 
# - The first row's value is 4 ( 8 / 2)
# - The second row's value is 3 ( 9 / 3)
# - The third row's value is 2 ( 6 / 3)
# - In this example, the sum of the results would be 4 + 3 + 2 = 9.
#
# Input: TSV file
# Output: Integer
#
# Current solution:
# Time complexity: O(n^3 + n log n) (I think?)
# Space complexity: O(n)
#
################################################################################

def find_checksum(file)
  row_values = []
  CSV.read(file, col_sep: "\t", converters: :numeric).each do |row|
    row_values << row.max - row.min
  end
  row_values.reduce(:+)
end

def find_checksum_part_two(file)
  row_values = []
  CSV.read(file, col_sep: "\t", converters: :numeric).each do |row|
    high_to_low = row.sort.reverse

    high_to_low.each_with_index do |current, index|
      high_to_low[index+1..row.length-1].each do |lower|
        if current % lower == 0
          row_values << current / lower
          break
        end
      end
    end
  end
  row_values.reduce(:+)
end

class  ChecksumFinderTest < Minitest::Test
  def test_example_case
    assert_equal(18, find_checksum("day_02_example_input.tsv"))

    assert_equal(9, find_checksum_part_two("day_02_example_input2.tsv"))
  end

  def test_time_peformance
    time = time_in_milliseconds { find_checksum("day_02_input.tsv") }
    assert(time < 1.0, "Greater than 1 ms: #{time}")

    time = time_in_milliseconds do
      find_checksum_part_two("day_02_input.tsv")
    end
    assert(time < 1.0, "Greater than 1 ms: #{time}")
  end

  def time_in_milliseconds(&block)
    time = Benchmark.realtime do
      yield block
    end
    time * 1000
  end
end

puts "#"*32 + " Part 1 Solution " + "#"*50
puts find_checksum("day_02_input.tsv")
puts "#"*100

puts "#"*32 + " Part 2 Solution " + "#"*50
puts find_checksum_part_two("day_02_input.tsv")
puts "#"*100
