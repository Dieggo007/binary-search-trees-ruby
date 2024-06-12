# frozen_string_literal: true

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  def leftmost_leaf
    node = self
    node = node.left while node.left
    node
  end

  def <=>(other)
    data <=> other.data
  end

  def <<(other)
    node, parent = navigate(other)
    return if node || parent.nil?

    if parent.right.nil?
      parent.right = other
    else
      parent.left = other
    end
  end

  def num_of_children
    children = 0
    children += 1 if left
    children += 1 if right
    children
  end

  def delete_child(other)
    if other == right
      self.right = nil
    elsif other == left
      self.left = nil
    end
  end

  def uniq_child
    return right if right && !left
    return left if left && !right

    nil
  end

  def delete(other, parent = nil)
    node, parent = navigate(other, parent)
    return if node.nil?

    if node.num_of_children.zero?
      parent&.delete_child(node)
    elsif node.num_of_children == 1
      node.data = node.uniq_child.data
      node.delete_child(node.uniq_child)
    else
      node.data, node.right.leftmost_leaf.data = node.right.leftmost_leaf.data, node.data
      node.right.delete(other, node)
    end
  end

  def navigate(other, parent = nil)
    node = self
    while node
      break if other == node
      yield node if block_given?
      parent = node
      node = other > node ? node.right : node.left
    end
    [node, parent]
  end

  def inorder(&block)
    return [*left&.inorder, data, *right&.inorder].compact unless block_given?

    left&.inorder(&block)
    yield self
    right&.inorder(&block)
  end

  def preorder(&block)
    return [data, *left&.preorder, *right&.preorder].compact unless block_given?

    yield self
    left&.preorder(&block)
    right&.preorder(&block)
  end

  def postorder(&block)
    return [*left&.postorder, *right&.postorder, data] unless block_given?

    left&.postorder(&block)
    right&.postorder(&block)
    yield self
  end

  def height
    return 0 if num_of_children.zero?

    1 + (right&.height.to_i > left&.height.to_i ? right&.height.to_i : left&.height.to_i)
  end

end
