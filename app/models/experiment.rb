# == Schema Information
#
# Table name: experiments
#
#  id                            :integer          not null, primary key
#  needs_adult_supervision       :boolean          default(FALSE)
#  is_active                     :boolean          default(FALSE)
#  active_at                     :datetime
#  slug                          :string(255)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  thumbnail1_file_name          :string(255)
#  thumbnail1_content_type       :string(255)
#  thumbnail1_file_size          :integer
#  thumbnail1_updated_at         :datetime
#  thumbnail2_file_name          :string(255)
#  thumbnail2_content_type       :string(255)
#  thumbnail2_file_size          :integer
#  thumbnail2_updated_at         :datetime
#  ingredient_image_file_name    :string(255)
#  ingredient_image_content_type :string(255)
#  ingredient_image_file_size    :integer
#  ingredient_image_updated_at   :datetime
#  gif_file_name                 :string(255)
#  gif_content_type              :string(255)
#  gif_file_size                 :integer
#  gif_updated_at                :datetime
#  youtube_url                   :string(255)
#

class Experiment < AddMissingTranslation

  #######################
  ## ATTACHED FILE
  has_attached_file :thumbnail1,
                    :url => "/system/experiments/:id/thumb1/:style.:extension",
                    :styles => {
                        :'xl' => {:geometry => "700x450#"},
                        :'big' => {:geometry => "426x284#"},
                        :'small' => {:geometry => "107x71#"}
                    }
  has_attached_file :thumbnail2,
                    :url => "/system/experiments/:id/thumb2/:style.:extension",
                    :styles => {
                        :'big' => {:geometry => "426x284#"},
                        :'small' => {:geometry => "107x71#"}
                    }
                    
  has_attached_file :ingredient_image,
                    :url => "/system/experiments/:id/ingredient_image/:style.:extension",
                    :styles => {
                        :'big' => {:geometry => "670x430#"},
                        :'small' => {:geometry => "134x86#"}
                    },
                    :convert_options => {
                      :'big' => '-quality 85',
                      :'small' => '-quality 85'
                    }
  has_attached_file :gif,
                    :url => "/system/experiments/:id/gif/:style.:extension"

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
  validates :youtube_url, :format => {:with => URI::regexp(['http','https'])}, :if => "!youtube_url.blank?"
  validates_attachment :thumbnail1,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] },
    size: { in: 0..4.megabytes }
  validates_attachment :thumbnail2,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] },
    size: { in: 0..4.megabytes }
  validates_attachment :ingredient_image,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] },
    size: { in: 0..4.megabytes }
  validates_attachment :gif,
    content_type: { content_type: ["image/gif"] },
    size: { in: 0..7.megabytes }

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
  scope :with_directions, -> {includes(directions: [:translations] )}
#  scope :with_directions, -> {includes(directions: [:translations, :images] )}

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
  ## METHODS
  def youtube_video_id
    if self.youtube_url.present?
      regex = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/
      result = regex.match(self.youtube_url)
      return result[1].present? ? result[1] : nil
    end
    return nil
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
