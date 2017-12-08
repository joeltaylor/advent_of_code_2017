require "minitest/autorun"
require "pry"

class RegisterJump
  def initialize(file)
    @file = file
    @registers = Hash.new {|h,k| h[k] = 0 }
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
  end
end

class TestRegisterJump < Minitest::Test
  def test_example
    assert_equal(1, RegisterJump.new("test_input.txt").resolve)
  end
end

puts "#"*100
puts RegisterJump.new("input.txt").resolve
puts "#"*100
