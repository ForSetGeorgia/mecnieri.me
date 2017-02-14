# Non-resource pages
class RootController < ApplicationController
  def index
  end

  def experiments
    @num = 3#6
    padding = 2
    if params[:page].nil? || params[:page].to_s == '1'
      @show_page_title = false

      @num = 5#11
      padding = 0
    end

    @experiments = Experiment.active.latest.search_for(params[:q]).by_category(params[:category]).page(params[:page]).per(@num).padding(padding)
    @total_experiments = @experiments.total_count 

    respond_to do |format|
      format.html
      format.js
    end
  end

  def experiment

    @show_page_title = false
    @body_class = 'experiment_show'

    begin

      @experiment = Experiment.active.with_ingredients.with_directions.friendly.find(params[:id])

      # build the next/prev links
      exp_ids = Experiment.active.latest.search_for(params[:q]).by_category(params[:category]).pluck(:id)
      current_id_index = exp_ids.index(@experiment.id)
      next_exp_id = current_id_index == exp_ids.length-1 ? exp_ids[0] : exp_ids[current_id_index+1]
      previous_exp_id = current_id_index == 0 ? exp_ids[-1] : exp_ids[current_id_index-1]
      @next_exp = Experiment.find(next_exp_id)
      @previous_exp = Experiment.find(previous_exp_id)

      respond_to do |format|
        format.html
        format.pdf {
          html = render_to_string(:layout => false , :action => "experiment_pdf.html.erb", :formats => [:html], :handler => [:erb])
          kit = PDFKit.new(html)
          filename = "random name"
          send_data(kit.to_pdf, :filename => "#{filename}.pdf", :type => 'application/pdf', :disposition  => "inline" )
          return # to avoid double render call
        }
      end

    rescue ActiveRecord::RecordNotFound  => e
      redirect_to experiments_path,
                alert: t('shared.msgs.does_not_exist')
    end

  end

  def about
    @is_about = true
  end
end
