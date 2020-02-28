require "immutable/vector"
require "immutable/list"

class Feeble::Reader
  def next(source, col = 1)
    reader = reader_with source
    token_content = ""

    while(char = reader.next) do
      token_content << char
      if token = tokenize(token_content, reader, col)
        return token
      end
    end

    raise "unrecognizable token #{token_content}"
  end

  def call(source)
    reader = Feeble::PushbackReader.new(source)
    col = 1

    tokens = Immutable::Vector.new
    while(!reader.eof?)
      token = self.next(reader, col)
      tokens = tokens.add token
      _, meta = token
      col = meta[:end] + 1
    end

    tokens
  end

  private

  def reader_with(source)
    return source if source.is_a? Feeble::PushbackReader

    Feeble::PushbackReader.new io_with(source)
  end

  def io_with(source)
    return source if source.is_a? StringIO

    # TODO: if source is a valid path, read file
    StringIO.new source
  end

  def tokenize(token_content, reader, col)
    return Immutable::Vector[token_content, {type: :separator, start: col, end: col}] if separator?(token_content)
    return Immutable::Vector[token_content, {type: :new_line, start: col, end: col}] if new_line?(token_content)

    delimiter = delimiters.find { |d| d.first == token_content }
    return read_delimited_token(delimiter, reader, col) if delimiter
  end

  def separator?(token_content)
    token_content == "\s" || token_content == ","
  end

  def new_line?(token_content)
    token_content == "\n"
  end

  def delimiters
    @delimiters ||= [
      ["\"", "\"",  :string],
      [";",  "\n",  :comment],
      ["[",  "]",   :vector, ->(content) { call(content) }],
      ["{",  "}",    :block, ->(content) { call(content) }],
      ["(",  ")",    :list, ->(content) { Immutable::List[*call(content)] }]
    ]
  end

  def read_delimited_token(delimiter, reader, col)
    open, close, type, transformer = delimiter
    transformer ||= (@_transformer ||= ->(content) { content })
    content = ""

    while((char = reader.next) && char != close)
      content << char
    end

    meta = (char == close || close == "\n") ? {} : {open: true }
    end_at = (open.length + content.length + close.length)
    meta = meta.merge(type: type, start: col, end: end_at )

    Immutable::Vector[transformer.call(content), meta]
  end
end