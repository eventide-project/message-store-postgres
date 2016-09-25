require_relative 'test_init'

TestBench::Runner.(
  'bench/**/*.rb',
  exclude_pattern: %r{/^skip_|(?:_init\.rb|\.sketch\.rb|_sketch\.rb|sketch\.rb|\.skip\.rb|_tests\.rb)\z}
) or exit 1
