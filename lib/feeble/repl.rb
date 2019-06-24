require "pry-byebug"

module Feeble
  class Repl
    COMMAND = /\A\//
    COMMANDS = {
      exit: /\Aexit$/i
    }

    def run
      puts "Feeble (REPL) #{Feeble::VERSION}"
      puts "  /[COMMAND]  (/exit to getoutahier!)\n\n\n"

      reader = Feeble::Reader::Code.new
      evaler = Feeble::Evaler::Lispey.new
      printer = Feeble::Printer::Expression.new
      env = Feeble::Language::Ruby::Fbl.new

      while true
        begin
          print "feeble > "

          input = gets.chomp

          break if execute(input) if COMMAND.match? input

          expressions = reader.read(input, env: env)
          result = expressions.reduce(nil) { |res, expression|
            res = evaler.eval expression, env: env
          }

          printer.print result
          $stdout.print "\n"
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
