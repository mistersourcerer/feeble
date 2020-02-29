class Feeble::Syntax::NumberFormatError < StandardError
  def initialize(invalid_number)
    msg = "Numbers should end in a separator (like ' ' or ',').\n"
    super msg + "Invalid number: #{invalid_number}"
  end
end
