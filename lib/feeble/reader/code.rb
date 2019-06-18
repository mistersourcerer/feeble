module Feeble::Reader
  class Code
    def read(code, env: nil)
      reader = Char.new code.strip
      component = ""
      values = []

      while reader.next
        # treat current (intermediary) component
        component << reader.current
      end

      # treat last component not recognized
      values << nil
    end
  end
end
