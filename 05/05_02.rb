require 'minitest/autorun'
class Navigator
  attr_reader :current_position, :total_steps, :maze

  def initialize(maze)
    @maze = maze
    @current_position = 0
    @total_steps = 0
  end

  def current_value
    @maze[@current_position]
  end

  def step
    previous_location = @current_position

    @total_steps +=1
    @current_position += @maze[@current_position]

    if @maze[previous_location] >= 3
      @maze[previous_location] += -1
    else
      @maze[previous_location] += 1
    end
  end

  def exited?
    @current_position >= @maze.length
  end
end

class TestNavigator < Minitest::Test
  def setup
    @navigator = Navigator.new([0, 3, 0, 1, -3])
  end

  def test_navigator
    until @navigator.exited? do
      @navigator.step
    end
    assert_equal(10, @navigator.total_steps)
    assert_equal([2, 3, 2, 3, -1], @navigator.maze)
  end
end

puts "#"*100
navigator = Navigator.new(File.open('input.txt').read.split("\n").map(&:to_i))
until navigator.exited? do
  navigator.step
end
puts navigator.total_steps
puts "#"*100
