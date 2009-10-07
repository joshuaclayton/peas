class PeasController < InheritedResources::Base
  respond_to :html
  actions :create, :show

  def redir; end
end
