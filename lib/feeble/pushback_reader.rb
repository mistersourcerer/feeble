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
    @buffer = []
  end

  def next
    return nil if eof?

    @buffer = @io.read(@chunk_size).chars if @buffer.length == 0
    @buffer.shift
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
end
