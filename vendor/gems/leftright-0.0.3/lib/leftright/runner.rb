# This is the replacement for Test::Unit::UI::Console::TestRunner

module LeftRight
  class Runner < Test::Unit::UI::Console::TestRunner
    # Access to the LeftRight module from the Runner instance. Hopefully to
    # reduce the likelyhood of future name clashes.
    #
    def lr
      LeftRight
    end

    # We intercept this to be able to set some pertinent state.
    #
    def test_started(test_name)
      name           = lr.extract_class_name test_name
      lr.state.class = lr.testcase_classes.detect { |c| c.name == name }

      super
    end

    # We intercept this to be able to set some pertinent state, as well as
    # change all remaining test methods in the current class to just skip,
    # since we already failed once at this point.
    #
    def add_fault(fault)
      lr.state.fault = fault
      lr.skip_testing_class lr.state.class

      super
    end

    # Test::Unit uses this method to print '.', 'F', 'E', and possibly
    # others. We do most of the work here, using the state saved in
    # 'add_fault' and 'test_finished'.
    #
    def output_single(captured, *etc)
      # Make sure we are printing a test result
      return super unless %w[ . F E ].include? captured

      # Do nothing if the method was a skipper
      return if lr.state.skip && '.' == captured

      output = case captured
        when '.' then lr.P
        when 'F' then lr.F
        when 'E' then lr.E
      end

      if lr.state.last_class_printed != lr.state.class
        # If we're here, we need to print a new class name on the left side
        lr.state.last_class_printed = lr.state.class
        lr.state.dots = 0
        @io.write "\n"
        @io.write lr.justify_left_side(
                    lr.format_class_name(lr.state.class.name))
      elsif captured != '.'
        # This handles the edge case when the first test for a class fails
        @io.write "\n"
        @io.write lr.justify_left_side
      end

      # Justify all lines but first:
      output.gsub! "\n", "\n" + lr.justify_left_side

      @io.write output
    ensure # reset all of the nasty state stuff
      @io.flush
      lr.state.previous_failed = captured != '.'
      lr.state.skip            = false
    end

    # This prints the final summary at the end of all tests.
    #
    def finished(elapsed_time)
      passed_count = @result.run_count     -
                     @result.failure_count -
                     @result.error_count   - lr.state.skipped_count

      total = { :passed  => passed_count,
                :failed  => @result.failure_count,
                :errors  => @result.error_count,
                :tests   => @result.run_count,
                :skipped => lr.state.skipped_count }

      results = []

      unless passed_count.zero?
        total[:passed] = 'all' if passed_count == @result.run_count
        results << lr::C.green("#{total[:passed]} passed")
      end

      unless lr.state.skipped_count.zero?
        results << lr::C.cyan("#{total[:skipped]} skipped")
      end

      unless @result.failure_count.zero?
        results << lr::C.red("#{total[:failed]} failed")
      end

      unless @result.error_count.zero?
        plural = @result.error_count > 1 ? 'errors' : 'error'
        results << lr::C.yellow("#{total[:errors]} #{plural}")
      end

      @io.write "\n"
      @io.write "\n" unless lr.state.previous_failed
      @io.write "#{total[:tests]} test#{'s' if @result.run_count > 1}: "
      @io.write results.join(', ').reverse.sub(',', 'dna ').reverse # :(
      @io.write "\n" + "\n"
      @io.puts "(#{elapsed_time} seconds)"
    end
  end
end