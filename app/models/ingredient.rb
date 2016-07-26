# == Schema Information
#
# Table name: ingredients
#
#  id            :integer          not null, primary key
#  experiment_id :integer
#  sort_order    :integer          default(1)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Ingredient < AddMissingTranslation
  #######################
  ## TRANSLATIONS

  translates :content, :fallbacks_for_empty_translations => true
  # Allows reference of specific translations, i.e. post.title_az
  # or post.title_en
  globalize_accessors

  #######################
  ## RELATIONSHIPS
  belongs_to :experiments

  #######################
  ## VALIDATIONS

  validates :content, :sort_order, presence: :true

  #######################
  ## SCOPES
  scope :sorted, -> { order(:sort_order) }


  #######################
  #######################
  private

  def has_required_translations?(trans)
    trans.content.present?
  end

  def add_missing_translations(default_trans)
    self.content = default_trans.content if self["content_#{Globalize.locale}"].blank?
  end
end
