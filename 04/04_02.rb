require 'minitest/autorun'
require 'pry'
require 'set'
################################################################################
# Part 2
#
# Task
# For added security, yet another system policy has been put in place. Now, a
# valid passphrase must contain no two words that are anagrams of each other -
# that is, a passphrase is invalid if any word's letters can be rearranged to
# form any other word in the passphrase.
#
# Example:
#
# - abcde fghij is a valid passphrase.
# - abcde xyz ecdab is not valid - the letters from the third word can be rearranged to form the first word.
# - a ab abc abd abf abj is a valid passphrase, because all letters need to be used when forming another word.
# - iiii oiii ooii oooi oooo is valid.
# - oiii ioii iioi iiio is not valid - any of these words can be rearranged to form any other word.
#
# Input: Text file
# Output: Integer
################################################################################

def count_valid_passwords(input)
  valid_count = 0

  File.readlines(input).each do |line|
    words = line.split(" ")
    phrases = Hash.new { |h,k| h[k] = 0 }

    words.each do |word|
      sorted_word = word.split('').sort.join('')
      phrases[sorted_word] += 1
    end
    valid_count +=1 if phrases.values.max == 1
  end

  valid_count
end


class CountValidPasswordsTest < Minitest::Test
  def test_example_case
    assert_equal(3, count_valid_passwords("test_example_two.txt"))
  end

  def test_input
    assert_equal(167, count_valid_passwords("input.txt"))
  end
end

puts "#"*100
puts "Part 3 Answer: #{count_valid_passwords("input.txt")}"
puts "#"*100
