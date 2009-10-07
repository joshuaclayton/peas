class PeasController < InheritedResources::Base
  respond_to :html
  actions :create, :show

  def create
    if (pea = Pea.find_by_long_url(params[:pea][:long_url]))
      return redirect_to(pea_path(pea))
    end
    create!
  end

  def redir
    pea = Pea.find_by_key(params[:pea_key])
    redirect_to(pea ? pea.long_url : root_path)
  end
end
