# coding: utf-8

# Run thor package:gem or gem build rango.gemspec
$:.unshift(File.join(File.dirname(__FILE__), "lib"))

begin
  require "rubygems/specification"
rescue SecurityError
  # http://gems.github.com
end

class Rango
  VERSION  = "0.0.2"
  CODENAME = "MVC Princess"
  SPECIFICATION = ::Gem::Specification.new do |s|
    s.name = "rango"
    # s.version = Rango::VERSION
    s.version = Rango::VERSION
    s.authors = ["Jakub Šťastný aka Botanicus"]
    s.homepage = "http://github.com/botanicus/rango"
    s.summary = "Rango is ultralightweight, ultracustomizable, ultracool web framework deeply inspired by Django."
    s.description = "" # TODO: long description
    s.cert_chain = nil
    s.email = ["knava.bestvinensis", "gmail.com"].join("@")
    s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
    s.executables = ["rango"]
    s.default_executable = "rango"
    s.add_dependency "rack"
    # s.add_dependency "thor"
    s.add_dependency "extlib"
    s.require_paths = ["lib"]
    s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")
    s.rubyforge_project = "rango"
  end
end
