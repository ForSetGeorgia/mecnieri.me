module CategoriesHelper

  def category_icon_path(category_slug)
    "categories/icons/#{category_slug}.svg"
  end

  def category_background_path(category_slug)
    "categories/backgrounds/#{category_slug}.svg"
  end
end
