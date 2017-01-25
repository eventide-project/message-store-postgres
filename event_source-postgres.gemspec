# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'evt-event_source-postgres'
  s.version = '0.12.1.1'
  s.summary = 'Event source client for PostgreSQL'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/event-source-postgres'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.3.3'

  s.add_runtime_dependency 'evt-event_source'
  s.add_runtime_dependency 'evt-log'
  s.add_runtime_dependency 'evt-cycle'
  s.add_runtime_dependency 'evt-settings'

  s.add_runtime_dependency 'pg'

  s.add_development_dependency 'test_bench'
end
