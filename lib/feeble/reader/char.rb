module Feeble::Reader
  class Char
    # TODO: consider enumerable...

    def initialize(string)
      # TODO: if string is a IO stream already, do not convert it.
      @io = StringIO.new(string)
      @started = true
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
  end
end
