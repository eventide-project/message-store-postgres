# -*- encoding: utf-8 -*-
Gem::Specification.new do |s|
  s.name = 'evt-message_store-postgres'
  s.version = '2.4.0.0'
  s.summary = 'Message store implementation for PostgreSQL'
  s.description = ' '

  s.authors = ['The Eventide Project']
  s.email = 'opensource@eventide-project.org'
  s.homepage = 'https://github.com/eventide-project/message-store-postgres'
  s.licenses = ['MIT']

  s.require_paths = ['lib']
  s.files = Dir.glob('{lib,database}/**/*')
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.4.0'

  s.executables = Dir.glob('scripts/evt-*').map(&File.method(:basename))
  s.bindir = 'scripts'

  s.add_runtime_dependency 'evt-message_store'
  s.add_runtime_dependency 'evt-log'
  s.add_runtime_dependency 'evt-settings'

  s.add_runtime_dependency 'message-db'
  s.add_runtime_dependency 'pg'

  s.add_development_dependency 'test_bench'
  s.add_development_dependency 'evt-diagnostics-sample'
  s.add_development_dependency 'ntl-actor'
end
