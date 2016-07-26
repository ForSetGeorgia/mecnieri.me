class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  authorize_resource

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.sorted
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit
  end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to [:admin,@category], notice: t('shared.msgs.success_created',
                            obj: t('activerecord.models.category', count: 1))}
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to [:admin,@category], notice: t('shared.msgs.success_updated',
                            obj: t('activerecord.models.category', count: 1))}
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to admin_categories_url, notice: t('shared.msgs.success_destroyed',
                              obj: t('activerecord.models.category', count: 1))}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      permitted = Category.globalize_attribute_names + [:is_active, :color_hex]
      params.require(:category).permit(*permitted)
    end
end
