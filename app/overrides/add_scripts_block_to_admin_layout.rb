Deface::Override.new(
  :virtual_path => 'spree/layouts/admin',
  :name => 'add_scripts_block_to_admin_layout',
  :insert_bottom => "body",
  :text => <<-HTML
    <%= yield :scripts if content_for?(:scripts) %>
  HTML
)
