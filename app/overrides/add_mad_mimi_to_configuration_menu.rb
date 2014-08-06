Deface::Override.new(
  :virtual_path => 'spree/admin/shared/_configuration_menu',
  :name => 'add_mad_mimi_to_configuration_menu',
  :insert_bottom => "[data-hook=admin_configurations_sidebar_menu]",
  :text => <<-HTML
    <%= configurations_sidebar_menu_item Spree.t('mad_mimi.admin.view.mad_mimi.edit.title'), edit_admin_mad_mimi_path %>
  HTML
)
