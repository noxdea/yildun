# frozen_string_literal: true

unless defined?(Data)
  Data = Struct
  def Data.define(*members)
    Struct.new(*members) do
      members.each { |member| undef_method("#{member}=") }
      define_method(:initialize) { |*values| super(*values).freeze }
    end
  end
end
