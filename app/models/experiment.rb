# == Schema Information
#
# Table name: experiments
#
#  id                      :integer          not null, primary key
#  needs_adult_supervision :boolean          default(FALSE)
#  is_active               :boolean          default(FALSE)
#  active_at               :datetime
#  slug                    :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Experiment < AddMissingTranslation

  #######################
  ## ATTACHED FILE
  has_attached_file :thumbnail1,
                    :url => "/system/experiments/:id/thumb1/:style.:extension",
                    :styles => {
                        :'big' => {:geometry => "426x284#"},
                        :'small' => {:geometry => "107x71#"}
                    },
                    :convert_options => {
                      :'big' => '-quality 85',
                      :'small' => '-quality 85'
                    }
  has_attached_file :thumbnail2,
                    :url => "/system/experiments/:id/thumb2/:style.:extension",
                    :styles => {
                        :'big' => {:geometry => "426x284#"},
                        :'small' => {:geometry => "107x71#"}
                    },
                    :convert_options => {
                      :'big' => '-quality 85',
                      :'small' => '-quality 85'
                    }

  #######################
  ## TRANSLATIONS

  translates :title, :intro, :explanation, :warning, :slug, :fallbacks_for_empty_translations => true
  # Allows reference of specific translations, i.e. post.title_az
  # or post.title_en
  globalize_accessors

  #######################
  ## RELATIONSHIPS
  has_and_belongs_to_many :categories
  has_many :directions, dependent: :destroy
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :directions, :reject_if => lambda { |x| x[:content_en].blank? && x[:content_ka].blank?}, allow_destroy: true
  accepts_nested_attributes_for :ingredients, :reject_if => lambda { |x| x[:content_en].blank? && x[:content_ka].blank?}, allow_destroy: true


  #######################
  ## SEARCHING

  scoped_search in: :translations, on: [:title, :intro, :explanation]
  ### NOTE - did not include the following models because could not figure out how to reference the the translation objects
  # scoped_search in: :direction_translations, on: :content
  # scoped_search in: :ingredient_translations, on: :content

  #######################
  ## VALIDATIONS

  validates :title, presence: :true, uniqueness: :true
  validates_attachment :thumbnail1,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] },
    size: { in: 0..4.megabytes }
  validates_attachment :thumbnail2,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] },
    size: { in: 0..4.megabytes }

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
    input.to_s.to_slug.normalize(transliterations: :georgian).to_s
  end

  #######################
  ## SCOPES
  scope :active, -> { where(is_active: true) }
  scope :sorted, -> { with_translations(I18n.locale).order(:title) }
  scope :latest, -> { with_translations(I18n.locale).order(active_at: :desc, title: :asc)}
  scope :with_ingredients, -> {includes(ingredients: [:translations] )}
  scope :with_directions, -> {includes(directions: [:translations, :images] )}

  def self.by_category(category_scope)
    if category_scope.present?
      begin
        c = Category.friendly.find(category_scope)
        return includes(:categories).where(categories: {id: c.id})
      rescue ActiveRecord::RecordNotFound  => e
        # do nothing
      end
    end
    return all
  end

  #######################
  ## CALLBACKS
  before_save :set_active_at

  # if the record is going public, save the date that this happened
  def set_active_at
    if self.is_active_changed? && self.is_active?
      self.active_at = Time.now
    end
    return true
  end

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
