require "test_helper"

class PeasControllerTest < ActionController::TestCase
  context "a GET to :show" do
    setup do
      @pea = Factory(:pea, :long_url => "http://www.google.com")
    end

    context "as HTML" do
      setup { get :show, :id => @pea.to_param }
      should_assign_to(:pea) { @pea }
      should_assign_to(:short_url) { peapod_url(@pea.key) }
      should_render_template :show
    end

    context "as JSON" do
      setup { get :show, :id => @pea.to_param, :format => "json" }

      should_respond_with_content_type :json

      should "contain the correct data" do
        json_response = ActiveSupport::JSON.decode(@response.body)
        assert_equal @pea.long_url, json_response["pea"]["long_url"]
        assert_equal peapod_url(@pea.key), json_response["pea"]["short_url"]
      end
    end

    context "as XML" do
      setup { get :show, :id => @pea.to_param, :format => "xml" }
      should_respond_with_content_type :xml

      should "contain the correct data" do
        assert_select "pea" do
          assert_select "short_url", peapod_url(@pea.key)
          assert_select "long_url", @pea.long_url
        end
      end
    end
  end
end
