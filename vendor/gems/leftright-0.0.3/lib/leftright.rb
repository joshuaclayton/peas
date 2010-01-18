require 'test/unit'
require 'test/unit/ui/console/testrunner'

require 'leftright/version' # to open the module

require 'leftright/color'
require 'leftright/runner'
require 'leftright/autorun'

module LeftRight
  # In counts of ' ':
  MID_SEPARATOR = 1
  RIGHT_MARGIN  = 1
  LEFT_MARGIN   = 1

  # This whole thing is fairly gnarly, needing to keep state across multiple
  # parts of the crazyness that is Test::Unit, so we keep it all here.
  #
  def self.state
    @state ||= begin
      fields = [
        :dots,               # the number of dots ('.') printed on this line
        :class,              # the TestCase-extending class being tested
        :fault,              # the current Test::Unit Failure/Error object
        :last_class_printed, # last class printed on the left side
        :previous_failed,    # true if the previous test failed/exceptioned
        :skip,               # true if the current test was a skip
        :skipped_count       # total number of skipped tests so far
      ]

      state = Struct.new(*fields).new
      state.skipped_count = 0
      state.dots          = 0
      state
    end
  end

  # Gets all descendants of Class that also descend from Test::Unit::TestCase
  #
  def self.testcase_classes
    @testcase_classes ||= begin
      found = []

      ObjectSpace.each_object(Class) do |klass|
        found << klass if Test::Unit::TestCase > klass
      end

      found
    end
  end

  # Replaces all instance methods beginning with 'test' in the given class
  # with stubs that skip testing.
  #
  def self.skip_testing_class(klass)
    klass.instance_methods.each do |m|
      if 'test' == m.to_s[0,4]
        klass.send :define_method, m.to_sym do
          ::LeftRight.state.skip = true
          ::LeftRight.state.skipped_count += 1
        end
      end
    end
  end

  # Formats a class name to display on the left side.
  #
  def self.format_class_name(class_name)
    class_name.chomp 'Test'
  end

  # Tries to get the terminal width in columns.
  #
  def self.terminal_width
    @terminal_width ||= STDOUT.tty? ? `stty size`.split[-1].to_i : 0 rescue 0
  end

  # Tries to get the left side width in columns.
  #
  def self.left_side_width
    @left_side_width ||= begin
      testcase_classes.map do |c|
        format_class_name(c.name).size + LEFT_MARGIN
      end.max
    end
  end

  # Tries to get the right side width in columns.
  #
  def self.right_side_width
    terminal_width - left_side_width
  end

  # Returns the given string, right-justified onto the left side.
  #
  def self.justify_left_side(str = '')
    str.to_s.rjust(left_side_width) + (' ' * MID_SEPARATOR)
  end

  # This gets the class name from the 'test_name' method on a
  # Test::Unit Failure or Error. They look like test_method_name(TestCase),
  #
  def self.extract_class_name(test_name)
    test_name.scan(/\(([^(|)]+)\)/x).flatten.last
  end

  # Wraps the given lines at word boundaries. Ripped right out of
  # http://blog.macromates.com/2006/wrapping-text-with-regular-expressions/
  #
  def self.wrap(line)
    return line unless STDOUT.tty?
    width = right_side_width - MID_SEPARATOR - RIGHT_MARGIN
    line.gsub /(.{1,#{width}})( +|$)\n?|(.{#{width}})/, "\\1\\3\n"
  end

  # Returns the current fault as a formatted failure message.
  #
  def self.F(color = C.red)
    # First, we wrap each line individually, to keep existing line breaks:
    lines = state.fault.long_display.split("\n")

    # Drop the redundant "Failure: ", "test: " (shoulda), "test_", etc
    lines.shift if lines.first.match /Failure:|Error:/
    lines.first.sub! /^test[\ |:|_]?/i,    ''

    # Drop the class name in () from the test method name
    lines.first.sub! /\(#{state.class}\)/, ''

    # shoulda puts '. :' at the end of method names
    lines.first.sub! /\.\ :\s?/, ':'

    # Wrap lines before coloring, since the wrapping would get confused
    # by non-printables.
    buffer = lines.map { |line| wrap line.strip }.join.strip

    # We make interesting parts of the failure message bold:
    [ /(`[^']+')/m,          # Stuff in `quotes'
      /("[^"]+")/m,          # Stuff in "quotes"
      /([^\/|\[]+\.rb:\d+)/, # Filenames with line numbers (without [box])
      /(\s+undefined\s+)/ ].each do |interesting|
      buffer.gsub! interesting, ( C.bold + '\0' + C.reset + color )
    end

    # These are great for assert_equal and similar:
    buffer.sub! /(<)(.*)(>\s+expected)/,
      '\1' + C.bold + '\2' + C.reset + color + '\3'
    buffer.sub! /(but\s+was\s+<)(.*)(>\.)/,
      '\1' + C.bold + '\2' + C.reset + color + '\3'

    color + buffer + C.reset + "\n"
  end

  # Returns the current fault as a formatted error message.
  #
  def self.E
    F C.yellow
  end

  # Returns a passing dot, aware of how many to print per-line.
  #
  def self.P
    return '.' unless STDOUT.tty?

    state.dots += 1

    max_dots = right_side_width - RIGHT_MARGIN - MID_SEPARATOR

    if state.dots >= max_dots
      state.dots = 1
      "\n" + C.green('.')
    else
      C.green '.'
    end
  end
end