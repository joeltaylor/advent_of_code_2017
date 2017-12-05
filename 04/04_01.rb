require 'minitest/autorun'
require 'pry'
require 'set'
################################################################################
# Part 1
#
# Task
# A new system policy has been put in place that requires all accounts to use a
# passphrase instead of simply a password. A passphrase consists of a series of
# words (lowercase letters) separated by spaces.
#
# To ensure security, a valid passphrase must contain no duplicate words.
#
# The system's full passphrase list is available as your puzzle input. How
# many passphrases are valid?
#
# Example:
#
# - aa bb cc dd ee is valid.
# - aa bb cc dd aa is not valid - the word aa appears more than once.
# - aa bb cc dd aaa is valid - aa and aaa count as different words.
#
# Input: Text file
# Output: Integer
################################################################################

def count_valid_passwords(input)
  valid_count = 0

  File.readlines(input).each do |line|
    words = line.split(" ")

    valid_count +=1 if Set.new(words).length == words.length
  end

  valid_count
end

class CountValidPasswordsTest < Minitest::Test
  def test_example_case
    assert_equal(2, count_valid_passwords("test_example.txt"))
  end
end

puts "#"*100
puts "Part 1 Answer: #{count_valid_passwords("input.txt")}"
puts "#"*100
