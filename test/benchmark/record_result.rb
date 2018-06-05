module Benchmark
  class RecordResult
    dependency :clock

    initializer :name, :content

    def self.build(name, content)
      instance = new(name, content)
      instance.configure
      instance
    end

    def self.call(name, content)
      instance = build(name, content)
      instance.()
    end

    def call
      digest, filename = write_result_file

      puts digest

      filename.to_s
    end

    def write_result_file
      fn = filename

      FileUtils.mkdir_p(fn.dirname)

      d = digest
      fn.write(d)

      [d, fn]
    end

    def filename
      time = clock.iso8601.gsub(':','-')
      directory = Pathname.new('test/benchmark/tmp')
      filename = directory.join("#{name} - #{time}.txt")

      filename
    end

    def digest
      <<~TEXT
        #{name}
        - - -
        #{content}
      TEXT
      .chomp
    end

    def configure
      Clock::UTC.configure(self)
    end
  end
end
