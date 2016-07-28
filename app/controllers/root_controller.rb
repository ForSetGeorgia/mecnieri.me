# Non-resource pages
class RootController < ApplicationController
  def index
    @categories = Category.active.sorted
  end

  def experiments
    @categories = Category.active.sorted
    @experiments = Experiment.active.latest
    @show_page_title = false
  end

  def experiment
    @experiment = Experiment.active.with_ingredients.with_directions.friendly.find(params[:id])

  end

  def about
  end
end
