ActionController::Routing::Routes.draw do |map|

  map.root :controller => "login"

  map.login 'login', :controller => 'login', :action => 'index'
  map.logout 'logout', :controller => 'login', :action => 'logout'
  
  map.with_options :controller => 'analyses' do |analyses|
    analyses.list_analysis '/overview',:action=>'overview'
    analyses.new_analysis '/analysis/new',:action=>'new'
    analyses.create_analysis '/analysis/create',:action=>'create'
    analyses.compare_analysis '/compare',:action=>'compare'
    analyses.edit_analyses '/edit',:action=>'edit_analyses'
    analyses.add_to_compare '/add_to_compare',:action=>'add_to_compare'
    analyses.remove_from_compare '/remove_from_compare',:action=>'remove_from_compare'
    analyses.edit_analysis '/analysis/:id/edit',:action=>'edit'
    analyses.update_analysis '/analysis/:id/update',:action=>'update'
    analyses.destroy_analysis '/analysis/:id/destroy',:action=>'destroy'
    analyses.view_analysis '/analysis/:id',:action=>'show'
  end

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
