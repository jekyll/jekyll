class StubCommand < Jekyll::Command
  class << self
    def init_with_program(prog)
      prog.command(:stub) do |c|
        c.syntax "stub [options]"
        c.description "Noop command"

        c.option "opts", "-o OPTS", "Any string; does nothing"

        c.action do |_args, _options|
          :noop
        end
      end
    end
  end
end
