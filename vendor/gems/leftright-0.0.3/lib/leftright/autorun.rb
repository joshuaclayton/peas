# This is the only monkeypatching we do in LeftRight, since
# Test::Unit::AutoRunner has no API for changing which runner to use. In
# fact, it has a hardcoded list of runners.

class Test::Unit::AutoRunner
  alias :initialize_without_leftright :initialize

  def initialize(*args)
    initialize_without_leftright *args
    @runner = lambda { |r| LeftRight::Runner }
  end
end