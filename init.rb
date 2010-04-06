require 'redmine'

RAILS_DEFAULT_LOGGER.info 'Menu Link plugin 0.0.1 for Redmine'

Redmine::Plugin.register :menu_link do
  name 'Menu Link Plugin'
  author 'Tide, Yuki Kita'
  description 'A plugin which adds a link to the top menu of Redmine.'
  version '0.0.1'

  settings :default => {
    'link_item_text' => 'http://www.google.com',
    'link_item_name' => 'Google',
    'new_window' => '0',
    'link_require_logged_in' => '0'
  }, :partial => 'settings/menulink_settings'
  menu(:top_menu,
      :link,
      Proc.new { Setting.plugin_menu_link['link_item_text'] },
      :caption => Proc.new { Setting.plugin_menu_link['link_item_name'] },
      :if => Proc.new { (Setting.plugin_menu_link['link_require_logged_in'] == '1') ? User.current.logged? : true })
end

class MenuListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    if Setting.plugin_menu_link['new_window'] == "0"
      Redmine::MenuManager.map(:top_menu).find(:link).html_options[:target] = nil
    else
      Redmine::MenuManager.map(:top_menu).find(:link).html_options[:target] = '_blank'
    end
    nil
  end
end

menu = Redmine::MenuManager.map(:top_menu).find(:link)
def menu.url
  @url.call
end

