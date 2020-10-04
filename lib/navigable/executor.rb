# frozen-string-literal: true

module Navigable
  class Executor
    def self.execute(&block)
      ENV['CONCURRENT_OBSERVERS'] ? Concurrent.global_io_executor.post(&block) : block.call
    end
  end
end
