require "minitest/autorun"
require "pry"

class RegisterJump
  attr_reader :max_value

  def initialize(file)
    @file = file
    @registers = Hash.new {|h,k| h[k] = 0 }
    @max_value = -Float::INFINITY
  end

  def resolve
    lines = File.readlines(@file).map(&:chomp)
    lines.map(&:split).map(&:first).each {|reg| @registers[reg] }
    lines.each do |line|
      action, conditional = line.split("if").map(&:strip).map(&:split)
      apply(*action) if condition(*conditional)
    end
    @registers.values.max
  end

  def condition(target, action, check)
    case action
    when ">"
      @registers[target] > check.to_i
    when ">="
      @registers[target] >= check.to_i
    when "<"
      @registers[target] < check.to_i
    when "<="
      @registers[target] <= check.to_i
    when "=="
      @registers[target] == check.to_i
    when "!="
      @registers[target] != check.to_i
    end
  end

  def apply(target, action, amount)
    if action == "inc"
      @registers[target] += amount.to_i
    else
      @registers[target] -= amount.to_i
    end
    @max_value = @registers[target] if @registers[target] > @max_value
  end
end

class TestRegisterJump < Minitest::Test
  def setup
    @subject = RegisterJump.new("test_input.txt")
  end

  def test_example
    assert_equal(1, @subject.resolve)
    assert_equal(10,@subject.max_value)
  end
end

puts "#"*100
r =  RegisterJump.new("input.txt")
r.resolve
puts r.max_value
puts "#"*100
