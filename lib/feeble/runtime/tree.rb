module Feeble::Runtime
  # TODO: Reimplement it in terms of a bitwise trie if the time comes. =)
  class Tree
    attr_accessor :value
    attr_reader :children

    def initialize
      @value = nil
      @children = {}
    end

    def search(pattern)
      node = self

      pattern.each_char.with_index do |char|
        if node.children.key? char
          node = node.children[char]
        else
          return nil
        end
      end

      node.value
    end

    def add(pattern, value)
      stopped_at = nil
      node = self

      pattern.each_char.with_index do |char, idx|
        if node.children.key? char
          node = node.children[char]
        else
          break stopped_at = idx
        end
      end

      # means the word is not here yet
      if stopped_at
        pattern[stopped_at..].each_char.with_index do |char, idx|
          node = node.children[char] = self.class.new
        end
      end

      node.value = value
    end
  end
end
