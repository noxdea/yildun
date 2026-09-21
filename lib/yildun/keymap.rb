# frozen_string_literal: true

module Yildun
  class Keymap
    def initialize(bindings = {})
      @bindings = bindings.to_h.transform_keys(&:to_s).freeze
    end

    def command(key) = @bindings[key.to_s]
    def include?(key) = @bindings.key?(key.to_s)
    def to_h = @bindings
  end
end
