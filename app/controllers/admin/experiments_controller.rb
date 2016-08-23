class Admin::ExperimentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_experiment, only: [:show, :edit, :update, :destroy]
  before_action :set_dropdowns, only: [:new, :edit, :create, :update]
  authorize_resource

  # GET /experiments
  # GET /experiments.json
  def index
    @experiments = Experiment.latest
  end

  # GET /experiments/1
  # GET /experiments/1.json
  def show
  end

  # GET /experiments/new
  def new
    @experiment = Experiment.new
  end

  # GET /experiments/1/edit
  def edit
  end

  # POST /experiments
  # POST /experiments.json
  def create
    @experiment = Experiment.new(experiment_params)

    respond_to do |format|
      if @experiment.save
        format.html { redirect_to [:admin,@experiment], notice: t('shared.msgs.success_created',
                            obj: t('activerecord.models.experiment', count: 1))}
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /experiments/1
  # PATCH/PUT /experiments/1.json
  def update
    respond_to do |format|
      if @experiment.update(experiment_params)
        format.html { redirect_to [:admin,@experiment], notice: t('shared.msgs.success_updated',
                            obj: t('activerecord.models.experiment', count: 1))}
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.json
  def destroy
    @experiment.destroy
    respond_to do |format|
      format.html { redirect_to admin_experiments_url, notice: t('shared.msgs.success_destroyed',
                              obj: t('activerecord.models.experiment', count: 1))}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_experiment
      @experiment = Experiment.with_ingredients.with_directions.friendly.find(params[:id])
    end

    # get data needed for drop downs
    def set_dropdowns
      @categories = Category.active.sorted

    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def experiment_params
      permitted = Experiment.globalize_attribute_names + [
        :is_active, :needs_adult_supervision, :thumbnail1, :thumbnail2, category_ids: [],
        directions_attributes: [
          Direction.globalize_attribute_names +
          [:id, :_destroy, :image, :sort_order, :experiment_id],
          images_attributes: [:id, :_destroy, :image, :sort_order, :direction_id]
        ],
        ingredients_attributes: [Direction.globalize_attribute_names + [:id, :_destroy, :sort_order, :experiment_id]]
      ]
      params.require(:experiment).permit(*permitted)
    end
end
