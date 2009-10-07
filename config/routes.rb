ActionController::Routing::Routes.draw do |map|
  map.root :controller => "high_voltage/pages", :action => "show", :id => "index"
  map.resources :peas
  map.peapod "/:pea_key", :controller => "peas", :action => "redir"
end
