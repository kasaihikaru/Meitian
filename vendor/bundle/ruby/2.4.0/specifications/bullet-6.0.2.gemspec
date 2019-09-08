# -*- encoding: utf-8 -*-
# stub: bullet 6.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "bullet".freeze
  s.version = "6.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/flyerhzm/bullet/blob/master/CHANGELOG.md", "source_code_uri" => "https://github.com/flyerhzm/bullet" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Richard Huang".freeze]
  s.date = "2019-08-20"
  s.description = "help to kill N+1 queries and unused eager loading.".freeze
  s.email = ["flyerhzm@gmail.com".freeze]
  s.homepage = "https://github.com/flyerhzm/bullet".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3".freeze)
  s.rubygems_version = "2.6.13".freeze
  s.summary = "help to kill N+1 queries and unused eager loading.".freeze

  s.installed_by_version = "2.6.13" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
      s.add_runtime_dependency(%q<uniform_notifier>.freeze, ["~> 1.11"])
    else
      s.add_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
      s.add_dependency(%q<uniform_notifier>.freeze, ["~> 1.11"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 3.0.0"])
    s.add_dependency(%q<uniform_notifier>.freeze, ["~> 1.11"])
  end
end
