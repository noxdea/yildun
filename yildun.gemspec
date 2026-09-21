# frozen_string_literal: true

require_relative "lib/yildun/version"

Gem::Specification.new do |spec|
  spec.name = "yildun"
  spec.version = Yildun::VERSION
  spec.authors = ["Yudai Takada"]
  spec.email = ["t.yudai92@gmail.com"]
  spec.summary = "A pure Ruby terminal application built on Tarazed"
  spec.description = "A terminal application shell with tabs, profiles, search, links, and Tarazed-backed sessions."
  spec.homepage = "https://github.com/noxdea/yildun"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1"
  spec.metadata = {
    "source_code_uri" => spec.homepage,
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "allowed_push_host" => "https://rubygems.org",
    "rubygems_mfa_required" => "true"
  }
  spec.files = Dir.chdir(__dir__) do
    Dir["{lib,sig,exe,assets,docs}/**/*", "README.md", "CHANGELOG.md", "LICENSE.txt"].select { |path| File.file?(path) }
  end
  spec.bindir = "exe"
  spec.executables = ["yildun"]
  spec.require_paths = ["lib"]
  spec.add_dependency "tarazed", ">= 0.2.6", "< 0.3"
end
