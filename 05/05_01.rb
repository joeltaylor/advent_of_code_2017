require 'minitest/autorun'
class Navigator
  attr_reader :current_position, :total_steps

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
    @maze[previous_location] += 1
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
    assert_equal(0, @navigator.current_position)
    assert_equal(0, @navigator.current_value)

    @navigator.step

    assert_equal(0, @navigator.current_position)
    assert_equal(1, @navigator.current_value)

    @navigator.step

    assert_equal(1, @navigator.current_position)
    assert_equal(3, @navigator.current_value)

    @navigator.step

    assert_equal(4, @navigator.current_position)
    assert_equal(-3, @navigator.current_value)

    @navigator.step

    assert_equal(1, @navigator.current_position)
    assert_equal(4, @navigator.current_value)

    @navigator.step
    assert @navigator.exited?
    assert_equal(5, @navigator.total_steps)
  end
end

puts "#"*100
navigator = Navigator.new(File.open('input.txt').read.split("\n").map(&:to_i))
until navigator.exited? do
  navigator.step
end
puts navigator.total_steps
puts "#"*100
