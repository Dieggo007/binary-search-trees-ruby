# frozen_string_literal: true

require './lib/tree'

array = (Array.new(15) { rand(1..100) })
tree = Tree.new(array)

tree.pretty_print

puts "is balanced?: #{tree.balanced?}"
puts "preorder:  #{tree.preorder}"
puts "postorder: #{tree.postorder}"
puts "inorder:   #{tree.inorder}"

3.times { tree.insert(rand(100..200)) }

tree.pretty_print

puts "is balanced?: #{tree.balanced?}"
tree.rebalance
tree.pretty_print
puts "is balanced?: #{tree.balanced?}"

puts "preorder:  #{tree.preorder}"
puts "postorder: #{tree.postorder}"
puts "inorder:   #{tree.inorder}"
