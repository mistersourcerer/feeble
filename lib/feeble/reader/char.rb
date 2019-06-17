require "logger"

module Feeble::Reader
  class Char
    # TODO: consider enumerable...

    def initialize(string, debug: false)
      # TODO: if string is a IO stream already, do not convert it.
      @io = StringIO.new(string)
      @started = false

      @logger = Logger.new(STDOUT)
      @logger.level = debug ? Logger::DEBUG : Logger::INFO
    end

    def start
      if @started
        self.current
      else
        self.next
      end
    end

    def next
      if @peek
        @current = @peek
        @peek = nil
        return @current
      end

      @started = true unless @started
      @current = @io.getc
    end

    def current
      @current
    end

    def peek
      return @peek if @peek

      current = @current
      @peek = self.next
      @current = current
      @peek
    end

    def eof?
      @peek == nil && @io.eof?
    end

    def until_next(pattern, &condition)
      condition ||=
        if pattern.is_a?(Regexp)
          ->(current_char, _) { pattern.match? current_char }
        else
          ->(current_char, _) { pattern == current_char }
        end

      read_until("Expected #{pattern} but nothing was found", &condition)
    end

    def read_until(raise_not_found = nil, &condition)
      condition ||= ->(_, _) { false }

      if condition.call(self.current, nil)
        @logger.debug "condition was immediately verified"
        @logger.debug "  looking to #{self.current}"
        @logger.debug "  raising < #{raise_not_found} >"
        @logger.debug "returning empty handed."

        return ""
      end

      string = self.current || ""
      found = false

      @logger.debug "starting #read_until"
      @logger.debug "  looking to #{self.current}"
      @logger.debug "  raising < #{raise_not_found} >"
      @logger.debug "  accumulated started with: #{string}"

      until(eof?)
        self.next

        @logger.debug "  now looking into: #{self.current}"

        if condition.call(self.current, string)

          @logger.debug "condition verified"
          @logger.debug "  accumulator is: #{string}"

          found = true
          break
        end

        string << current

        @logger.debug "iterating, accumulator is: #{string}"
      end

      @logger.debug "Out of loop"
      @logger.debug "  looking to #{self.current}"
      @logger.debug "  accumulator is: #{string}"
      @logger.debug "  found? < #{found} > AND raise: < #{raise_not_found} >"
      raise raise_not_found if !found && !raise_not_found.nil?

      string
    end

    def logger_level(level)
      @logger.level = level
    end
  end
end
