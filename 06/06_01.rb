require "minitest/autorun"
require "set"

class MemoryRedistribution
  def initialize(blocks)
    @blocks = blocks
    @divisor = blocks.length - 1
  end

  def redistribute
    value, index = @blocks.max
    index = @blocks.index(value)
    @blocks[index] = 0

    next_index = index + 1

    until value == 0 do
      @blocks[next_index % @blocks.length] += 1
      next_index += 1
      value -= 1
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
m = MemoryRedistribution.new(File.open("input.txt").read.split(" ").map(&:to_i))
while true do
  res = m.redistribute
  steps += 1
  break if log.include? res
  log << res
end
puts steps
puts "#"*100
