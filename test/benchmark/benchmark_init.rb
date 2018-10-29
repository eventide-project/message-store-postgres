require_relative '../test_init'

Dependency.activate
Initializer.activate

require 'diagnostics/sample'
require 'fileutils'
require 'pathname'

require_relative 'defaults'
require_relative 'record_result'
