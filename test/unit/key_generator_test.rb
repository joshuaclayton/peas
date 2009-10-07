require "test_helper"

class KeyGeneratorTest < ActiveSupport::TestCase
  should "properly generate keys" do
    assert_equal "A", KeyGenerator.generate(1)
    assert_equal "a", KeyGenerator.generate(27)
    assert_equal "0", KeyGenerator.generate(53)
    assert_equal "BA", KeyGenerator.generate(63)
  end
end
