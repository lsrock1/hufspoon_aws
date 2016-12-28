module HomeHelper
  def menu_cache_key menu
    "menus-#{menu['name']}-#{menu['update']}-#{menu['id']}"
  end
end
