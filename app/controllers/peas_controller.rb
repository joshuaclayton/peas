class PeasController < InheritedResources::Base
  respond_to :html, :xml, :json
  actions :create, :show

  def show
    show! do |format|
      @short_url = peapod_url(@pea.key)
      format.json do
        render :json => {
          :pea => {
            :long_url => @pea.long_url,
            :short_url => @short_url
          }
        }
      end
    end
  end

  def create
    if (pea = Pea.find_by_long_url(params[:pea][:long_url]))
      return redirect_to(pea_path(pea))
    end
    create! do |success, failure|
      failure.html { redirect_to root_path }
    end
  end

  def redir
    pea = Pea.find_by_key(params[:pea_key])
    redirect_to(pea && pea.long_url != peapod_url(pea.key) ? pea.long_url : root_path)
  end
end
