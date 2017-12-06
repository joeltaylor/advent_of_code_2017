require "minitest/autorun"
require 'pry'
require "set"

class MemoryRedistribution
  def initialize(blocks)
    @blocks = blocks
    @divisor = blocks.length - 1
  end

  def redistribute
    max_value = @blocks.max
    distribution = [max_value / @divisor, 1].max
    index_of_max_value = @blocks.index(max_value)
    new = max_value < @divisor ? 0 : max_value % @divisor
    @blocks[index_of_max_value] = new
    next_index = index_of_max_value += 1

    remaining = max_value - new
    until remaining <= 0 do
      next_index = 0 if next_index > @blocks.length - 1
      @blocks[next_index] += distribution
      remaining -= distribution
      next_index += 1
    end
    @blocks
  end

end

class TestMemoryRedistribution < Minitest::Test
  def setup
    @subject = MemoryRedistribution.new([0, 2, 7, 0])
  end

  def test_redistribution
    assert_equal([2,4,1,2], @subject.redistribute)
    assert_equal([3,1,2,3], @subject.redistribute)
    assert_equal([0,2,3,4], @subject.redistribute)
    assert_equal([1,3,4,1], @subject.redistribute)
    assert_equal([2,4,1,2], @subject.redistribute)
  end
end

puts "#"*100
log = Set.new
steps = 0
cycle_count = 0
seen_state = false
target = nil
m = MemoryRedistribution.new(File.open("input.txt").read.split(" ").map(&:to_i))
while true do
  res = m.redistribute
  steps += 1
  seen_state = true if log.include? res
  break if target == res
  if !target && seen_state
    target = res.dup
  end
  cycle_count += 1 if seen_state
  log << res
end
puts cycle_count
puts "#"*100
