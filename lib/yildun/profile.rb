# frozen_string_literal: true

module Yildun
  Profile = Data.define(:name, :command, :env, :cwd)

  module_function

  def profile(settings, name = settings.fetch("default_profile"))
    value = settings.profile(name)
    Profile.new(name.to_s, Array(value.fetch("command")), value.fetch("env", {}), value["cwd"])
  end
end
