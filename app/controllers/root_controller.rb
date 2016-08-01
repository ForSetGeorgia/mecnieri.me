# Non-resource pages
class RootController < ApplicationController
  def index
    @categories = Category.active.sorted
  end

  def experiments
    @categories = Category.active.sorted
    @experiments = Experiment.active.latest.search_for(params[:q])
    @show_page_title = false
  end

  def experiment
    begin

      @experiment = Experiment.active.with_ingredients.with_directions.friendly.find(params[:id])

    rescue ActiveRecord::RecordNotFound  => e
      redirect_to experiments_path,
                alert: t('shared.msgs.does_not_exist')
    end

  end

  def about
  end
end
