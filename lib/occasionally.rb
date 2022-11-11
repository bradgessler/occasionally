# frozen_string_literal: true

require 'logger'

module Occassionally
  class Job
    attr_accessor :interval, :block

    def initialize(interval:, &block)
      @interval = interval
      @block = block
    end

    def run
      @block.call
    end
  end

  class Schedule
    attr_accessor :jobs

    def initialize
      @jobs = []
    end
  end

  class Runner
    attr_accessor :schedule, :logger

    def initialize(schedule, logger: self.class.logger)
      @schedule = schedule
      @logger = logger
    end

    def run
      ppid = Process.pid

      schedule.jobs.each do |job|
        fork do
          logger.info "Forked #{job.inspect} to pid #{Process.pid}"
          Process.setproctitle("ruby #{job.inspect}")

          loop do
            if ppid != Process.ppid
              logger.info "Exiting #{job.inspect}"
              Process.exit!(true)
            end
            logger.info "Running job #{job.inspect}"
            job.run
          rescue => e
            logger.error "Error job #{job.inspect}: #{e.inspect}"
          ensure
            logger.error "Scheduling #{job.inspect} to run in #{job.interval} seconds"
            sleep job.interval
          end
        end
      end
    end

    def self.logger
      Logger.new(STDOUT)
    end
  end

  class DSL
    def initialize(schedule)
      @schedule = schedule
      @runner = Runner.new(@schedule)
    end

    def every(interval, &block)
      @schedule.jobs << Job.new(interval: interval.to_i, &block)
    end

    def run
      @runner.run
    end

    def logger(logger)
      @runner.logger = logger
    end
  end

  class << self
    def schedule(&block)
      @schedule ||= Schedule.new
      configure(@schedule, &block) if block_given?
      @schedule
    end

    def configure(schedule, &block)
      DSL.new(schedule).instance_eval(&block)
    end
  end
end
