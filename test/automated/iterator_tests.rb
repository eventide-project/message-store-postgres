require_relative '../test_init'

TestBench::Runner.(
  'iterator/**/*.rb'
) or exit 1
