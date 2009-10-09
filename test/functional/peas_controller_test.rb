require "test_helper"

class PeasControllerTest < ActionController::TestCase
  context "a GET to :show" do
    setup do
      @pea = Factory(:pea, :long_url => "http://www.google.com")
    end

    context "as HTML" do
      setup { get :show, :id => @pea.to_param }
      should_assign_to(:pea) { @pea }
      should_render_template :show
    end

    context "as JSON" do
      setup { get :show, :id => @pea.to_param, :format => "json" }
      should_respond_with_content_type :json
    end

    context "as XML" do
      setup { get :show, :id => @pea.to_param, :format => "xml" }
      should_respond_with_content_type :xml
    end
  end
end
