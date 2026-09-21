# frozen_string_literal: true

module Yildun
  class Pane
    attr_reader :children, :orientation

    def initialize(tab = nil, orientation: :leaf)
      @children, @orientation = tab ? [tab] : [], orientation
    end

    def leaf? = @orientation == :leaf
    def split(tab, orientation: :horizontal)
      if leaf? && @children.empty?
        @children << (tab.is_a?(Pane) ? tab : Pane.new(tab))
        return self
      end

      if leaf?
        existing = @children.map { |child| child.is_a?(Pane) ? child : Pane.new(child) }
        @children = existing
      end
      @orientation = orientation
      @children << (tab.is_a?(Pane) ? tab : Pane.new(tab))
      self
    end
  end
end
