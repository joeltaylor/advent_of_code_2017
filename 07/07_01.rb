require "minitest/autorun"
require "pry"


class Node
  attr_reader :name, :parent
  def initialize(name, parent = nil)
    @name = name
    @parent = parent
  end
end

class Graph
  attr_reader :nodes
  def initialize
    @nodes = {}
  end

  def [](name)
    @nodes[name]
  end

  def add(details)
    node_name, weight, children = details.split(/ /, 4).tap {|s| s.delete("->")}
    node = Node.new(node_name)
    node_children = []
    if children
      children.split(",").map(&:lstrip).each do |name|
          new_node = Node.new(name, node)
          @nodes[name] = new_node
      end
    end

    unless @nodes.has_key? node_name
      @nodes[node_name] = node
    end
  end

  def find_root
    @nodes.select { |name, node| !node.parent }.values.first.name
  end
end

class TestRecursiveCircus < Minitest::Test
  def test_graph_building
    graph = Graph.new
    graph.add("aaa (60) -> bbb, ccc")
    graph.add("bbb (10) -> eee")
    assert graph["aaa"]
    assert graph["bbb"]
    assert graph["ccc"]
    assert graph["eee"]

    assert_equal("aaa", graph["bbb"].parent.name)
  end

  def test_parent_finder
    graph = Graph.new
    graph.add("ccc (10)")
    graph.add("ddd (10)")
    graph.add("jel (10)")
    graph.add("bbb (10) -> zzz, ddd, dee")
    graph.add("aaa (60) -> bbb, ccc")
    graph.add("dee (60) -> jel")


    assert_equal("aaa", graph.find_root)
    assert_equal(1, graph.nodes.select{|k,v| !v.parent }.count)
  end

  def test_example
    graph = Graph.new
    File.open("test_input.txt").readlines.map(&:chomp).each {|line| graph.add(line) }
    assert_equal("tknk", graph.find_root)
  end
end

puts "#"*100
graph = Graph.new
File.open("input.txt").readlines.map(&:chomp).each {|line| graph.add(line)}
puts graph.find_root
puts "#"*100

