# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  is_active  :boolean          default(TRUE)
#  slug       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  color_hex  :string(255)
#

class Category < AddMissingTranslation

  #######################
  ## TRANSLATIONS

  translates :title, :description, :slug, :fallbacks_for_empty_translations => true
  # Allows reference of specific translations, i.e. post.title_az
  # or post.title_en
  globalize_accessors

  #######################
  ## RELATIONSHIPS
  has_and_belongs_to_many :experiments

  #######################
  ## VALIDATIONS

  validates :title, :color_hex, presence: :true, uniqueness: :true

  #######################
  ## SLUG DEFINITION (friendly_id)

  extend FriendlyId
  friendly_id :title, use: [:globalize, :history, :slugged]

  # for genereate friendly_id
  def should_generate_new_friendly_id?
#    name_changed? || super
    super
  end

  # for locale sensitive transliteration with friendly_id
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize.to_s
  end

  #######################
  ## SCOPES
  scope :active, -> { where(is_active: true) }
  scope :sorted, -> { with_translations(I18n.locale).order(:title) }

  #######################
  #######################
  private

  def has_required_translations?(trans)
    trans.title.present?
  end

  def add_missing_translations(default_trans)
    self.title = default_trans.title if self["title_#{Globalize.locale}"].blank?
  end
end
