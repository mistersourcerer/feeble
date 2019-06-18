module Feeble
  class Repl
    COMMAND = /\A\//
    COMMANDS = {
      exit: /\Aexit$/i
    }

    def run
      puts "Feeble (REPL) #{Feeble::VERSION}"
      puts "  /[COMMAND]  (/exit to getoutahier!)\n\n\n"

      while true
        begin
          print "feeble > "
          input = gets

          break if execute(input) if COMMAND.match? input

          # result = eval read(input)
          # puts " > #{print result}"

          puts " > #{nil}"
        rescue StandardError => e
          puts "  !error > #{e.message}"
          puts "  !error > inspect? [Y/n]"
          res = gets.chomp.downcase
          if res == "y" || res == "yes" || res == ""
            pp e.backtrace
          end
        end
      end
    end

    private

    def execute(cmd)
      command = cmd.chomp[1..]

      case command
      when COMMANDS[:exit]
        $stdout.puts "Bye!"
        true
      end
    end
  end
end
