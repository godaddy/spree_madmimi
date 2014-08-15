Deface::Override.new(
  :virtual_path => 'spree/layouts/spree_application',
  :name => 'add_mad_mimi_to_configuration_menu',
  :insert_bottom => "body",
  :text => <<-HTML
    <%= mad_mimi_webform %>
  HTML
)
