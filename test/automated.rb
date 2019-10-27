require_relative './test_init'

TestBench::CLI.(
  tests_directory: 'test/automated',
  exclude_file_pattern: %r{/_|sketch|(_init\.rb|_tests\.rb)\z}
)
