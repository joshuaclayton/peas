require "test_helper"

class PeaTest < ActiveSupport::TestCase
  should_validate_presence_of :long_url

  context "A pea" do
    subject { Factory(:pea) }

    should_validate_uniqueness_of :key, :long_url
  end

  context "An unsaved pea" do
    setup { @pea = Factory.build(:pea) }

    should "generate a key after it's created" do
      assert_nil @pea.key
      @pea.save
      assert @pea.key.present?
    end
  end
end
