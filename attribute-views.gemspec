# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{attribute-views}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Manfred Stienstra"]
  s.date = %q{2009-06-29}
  s.description = %q{A plugin converting between value objects and record columns.}
  s.email = %q{manfred@fngtps.com}
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.files = ["lib/active_record/attribute_views.rb", "rails/init.rb", "README.rdoc", "LICENSE"]
  s.has_rdoc = true
  s.homepage = %q{http://fingertips.github.com}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{A plugin converting between value objects and record columns.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
