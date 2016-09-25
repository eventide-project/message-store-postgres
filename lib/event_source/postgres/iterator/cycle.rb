module EventStream
  module Postgres
    class Iterator
      class Cycle
        dependency :clock, Clock::UTC
        dependency :telemetry, Telemetry
        dependency :logger, Telemetry::Logger

        def delay_milliseconds
          @delay_milliseconds ||= Defaults.delay_milliseconds
        end

        def delay_condition
          @delay_condition ||= Defaults.delay_condition
        end

        initializer na(:delay_milliseconds), :timeout_milliseconds, na(:delay_condition)

        def self.build(delay_milliseconds: nil, timeout_milliseconds: nil, delay_condition: nil)
          new(delay_milliseconds, timeout_milliseconds, delay_condition).tap do |instance|
            instance.configure
          end
        end

        def self.configure(receiver, attr_name: nil, delay_milliseconds: nil, timeout_milliseconds: nil, delay_condition: nil, cycle: nil)
          attr_name ||= :cycle

          if !cycle.nil?
            instance = cycle
          else
            if delay_milliseconds.nil? && timeout_milliseconds.nil?
              instance = None.build
            else
              instance = build(delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, delay_condition: delay_condition)
            end
          end

          receiver.public_send "#{attr_name}=", instance
        end

        def configure
          Clock::UTC.configure self
          ::Telemetry.configure self
          ::Telemetry::Logger.configure self
        end

        def self.call(delay_milliseconds: nil, timeout_milliseconds: nil, delay_condition: nil, &action)
          instance = build(delay_milliseconds: delay_milliseconds, timeout_milliseconds: timeout_milliseconds, delay_condition: delay_condition)
          instance.call(&action)
        end

        def call(&action)
          stop_time = nil
          if !timeout_milliseconds.nil?
            stop_time = clock.now + (timeout_milliseconds.to_f / 1000.0)
          end

          logger.opt_trace "Cycling (Delay Milliseconds: #{delay_milliseconds}, Timeout Milliseconds: #{timeout_milliseconds.inspect}, Stop Time: #{clock.iso8601(stop_time)})"

          iteration = -1
          result = nil
          loop do
            iteration += 1
            telemetry.record :cycle, iteration

            result = invoke(iteration, &action)

            if delay_condition.(result)
              logger.opt_debug "No results (Iteration: #{iteration})"
              delay
            else
              logger.opt_debug "Got results (Iteration: #{iteration})"
              telemetry.record :got_result
              break
            end

            if !timeout_milliseconds.nil?
              now = clock.now
              if now >= stop_time
                logger.opt_debug "Timeout has lapsed (Iteration: #{iteration}, Stop Time: #{clock.iso8601(stop_time)}, Timeout Milliseconds: #{timeout_milliseconds})"
                telemetry.record :timed_out, now
                break
              end
            end
          end

          logger.opt_trace "Cycled (Iterations: #{iteration}, Delay Milliseconds: #{delay_milliseconds}, Timeout Milliseconds: #{timeout_milliseconds.inspect}, Stop Time: #{clock.iso8601(stop_time)})"

          return result
        end

        def invoke(iteration, &action)
          logger.opt_trace "Invoking action (Iteration: #{iteration})"

          result = action.call
          telemetry.record :invoked_action

          logger.opt_debug "Invoked action (Iteration: #{iteration})"

          result
        end

        def delay
          logger.opt_trace "Delaying (Milliseconds: #{delay_milliseconds})"

          delay_seconds = (delay_milliseconds.to_f / 1000.0)

          sleep delay_seconds

          telemetry.record :delayed, delay_milliseconds

          logger.opt_debug "Finished delaying (Milliseconds: #{delay_milliseconds})"
        end

        def self.register_telemetry_sink(writer)
          sink = Telemetry.sink
          writer.telemetry.register sink
          sink
        end

        module Telemetry
          class Sink
            include ::Telemetry::Sink

            record :cycle
            record :invoked_action
            record :got_result
            record :delayed
            record :timed_out
          end

          Data = Struct.new :milliseconds

          def self.sink
            Sink.new
          end
        end

        module Substitute
          def self.build
            Cycle::None.build.tap do |instance|
              sink = Cycle.register_telemetry_sink(instance)
              instance.sink = sink
            end
          end
        end

        class None < Cycle
          attr_accessor :sink

          def call(&action)
            action.call
          end
        end

        module Defaults
          def self.delay_milliseconds
            200
          end

          def self.delay_condition
            lambda do |result|
              if result.respond_to? :empty?
                result.empty?
              else
                result.nil?
              end
            end
          end
        end
      end
    end
  end
end
