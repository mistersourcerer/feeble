class Feeble::PushbackReader
  def self.with(io, chunk_size: 16384)
    raise "Pass the block that will receive the pushback reader" if !block_given?

    reader = new(io, chunk_size: chunk_size)
    yield(reader)
    reader.close
  end

  def initialize(io, chunk_size: 16384)
    @io = io.is_a?(String) ? StringIO.new(io) : io
    @chunk_size = chunk_size
    @started = nil
    @buffer = []
  end

  def next
    return nil if eof?

    @started ||= true
    bufferize if @buffer.length == 0
    @buffer.shift
  end

  def peek(length = 1)
    bufferize if !@started
    str = @buffer[0...length]
    str.length > 0 ? str.join : nil
  end

  def push(string)
    @buffer = string.to_s.chars + @buffer
  end

  def eof?
    @buffer.length == 0 && @io.eof?
  end

  def close
    @io.close
  end

  private

  def bufferize
    @buffer = @io.read(@chunk_size).chars
  end
end
