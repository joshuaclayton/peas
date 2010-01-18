# This is just here to avoid depending on Term::ANSIColor and such, since
# we need so little, and need it to transparently do nothing when
# STDOUT is not a terminal.

module LeftRight
  module C
    if STDOUT.tty?
      def self.color(args)
        name, code = args.keys.first, args.values.first

        eval %' def self.#{name}(string = nil)
          string.nil? ? "\e[#{code}m" : "\e[#{code}m" + string + "\e[0m"
        end ', binding, __FILE__, __LINE__
      end

      color :red    => 31
      color :green  => 32
      color :yellow => 33
      color :cyan   => 36
      color :reset  => 0
      color :bold   => 1
    else
      def self.method_missing(color, *args)
        args.first.nil? ? '' : args.first
      end
    end
  end
end