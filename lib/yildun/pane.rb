# frozen_string_literal: true

module Yildun
  class Pane
    attr_reader :children, :orientation

    def initialize(tab = nil, orientation: :leaf)
      @children, @orientation = tab ? [tab] : [], orientation
    end

    def leaf? = @orientation == :leaf
    def split(tab, orientation: :horizontal)
      return Pane.new(tab, orientation: orientation) if leaf? && @children.empty?
      @orientation = orientation
      @children << (tab.is_a?(Pane) ? tab : Pane.new(tab))
      self
    end
  end
end
