# frozen_string_literal: true
require './lib/node'
class Tree

  attr_accessor :root

  def initialize(array)
    array = array.uniq.sort { |a, b| a - b }
    @root = build_tree(array)
  end

  def build_tree(array)
    middle = (array.length - 1) / 2
    node = Node.new(array[middle])
    return node if array.length <= 1

    node.right = build_tree(array[(middle + 1)..])
    node.left = build_tree(array[0..(middle - 1)]) if middle >= 1
    node
  end

  def insert(data)
    new_node = Node.new(data)
    if @root
      @root << new_node
    else
      @root = new_node
    end
  end

  def delete(data)
    @root.delete(Node.new(data))
  end

  def find(value)
    node = Node.new(value)
    found, = @root.navigate(node)
    found
  end

  def level_order_traversal
    queue = []
    queue << @root if @root
    while queue.any?
      current_node = queue.shift
      yield current_node
      queue << current_node.left if current_node.left
      queue << current_node.right if current_node.right
    end
  end

  def level_order_traversal_recursive(queue = [@root], &block)
    current_node = queue.shift
    yield current_node
    queue << current_node.left if current_node.left
    queue << current_node.right if current_node.right
    level_order_traversal_recursive(queue, &block) if queue.any?
  end

  def inorder(&block)
    @root.inorder(&block)
  end

  def preorder(&block)
    @root.preorder(&block)
  end

  def postorder(&block)
    @root.postorder(&block)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def height(node)
    node.height
  end

  def depth(node)
    nivel = 0
    @root.navigate(node) { nivel += 1 }
    nivel
  end

  def balanced?
    height_left = @root.left&.height.to_i
    height_right = @root.right&.height.to_i
    (height_left - height_right).abs <= 1
  end

  def rebalance
    return if balanced?

    array_tree = @root.inorder
    @root = build_tree(array_tree)
  end

end






