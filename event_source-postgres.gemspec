# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'event_stream-postgres'
  s.version = '0.0.0.0'
  s.summary = 'Event stream client for PostgreSQL'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/event-stream-postgres'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.2.3'

  s.executables = ['install-event-stream-database', 'uninstall-event-stream-database']
  s.bindir = 'bin'

  s.add_runtime_dependency 'telemetry'
  s.add_runtime_dependency 'telemetry-logger'
  s.add_runtime_dependency 'casing'
  s.add_runtime_dependency 'schema'
  s.add_runtime_dependency 'initializer'
  s.add_runtime_dependency 'serialize'
  s.add_runtime_dependency 'settings'
  s.add_runtime_dependency 'async_invocation'
  s.add_runtime_dependency 'controls'

  s.add_runtime_dependency 'pg'

  s.add_development_dependency 'test_bench'
end
