class PeasController < InheritedResources::Base
  respond_to :html
  actions :create, :show

  def redir
    pea = Pea.find_by_key(params[:pea_key])
    redirect_to(pea ? pea.long_url : root_path)
  end
end
