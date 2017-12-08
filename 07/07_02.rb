require "minitest/autorun"
require "pry"


class Node
  attr_reader :name, :weight, :parent
  attr_writer :parent, :weight
  def initialize(name, weight, parent = nil)
    @name = name
    @weight = weight.gsub!(/[(,)]/,"").to_i
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
    node = Node.new(node_name, weight)
    node_children = []
    if children
      children.split(",").map(&:lstrip).each do |name|
          new_node = Node.new(name, weight, node)
          if @nodes[name]
            @nodes[name].parent = node
          else
            @nodes[name] = new_node
          end
      end
    end

    if !@nodes.has_key? node_name
      @nodes[node_name] = node
    else
      @nodes[node_name].weight = weight.to_i
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
    assert graph.nodes.select {|_, n| n.weight == 0 }.empty?
  end
end

def children(parent)
  ch = @nodes.select {|_, n| n.parent && n.parent.name == parent.name}
  return nil if ch.empty?
  ch.values
end

def find_weight(node)
  weight = node.weight
  return weight unless children(node)

  res = children(node).map do |child|
    weight += find_weight(child)
  end

  return weight
end

puts "#"*100
graph = Graph.new
File.open("input.txt").readlines.map(&:chomp).each {|line| graph.add(line) }

@nodes = graph.nodes
root = @nodes[graph.find_root]

base = children(root)
weights =  base.collect {|ch| find_weight(ch)}
# Traverse manually
binding.pry
puts "#"*100
