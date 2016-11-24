# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_source-postgres'
  s.version = '0.9.0.0'
  s.summary = 'Event source client for PostgreSQL'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/event-source-postgres'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'

  s.add_runtime_dependency 'event_source'
  s.add_runtime_dependency 'log'
  s.add_runtime_dependency 'cycle'
  s.add_runtime_dependency 'settings'

  s.add_runtime_dependency 'pg'

  s.add_development_dependency 'test_bench'
end
