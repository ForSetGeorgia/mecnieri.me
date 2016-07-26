# == Schema Information
#
# Table name: directions
#
#  id                 :integer          not null, primary key
#  experiment_id      :integer
#  sort_order         :integer          default(1)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class Direction < AddMissingTranslation
  #######################
  ## ATTACHED FILE
  has_attached_file :image,
                    :url => "/system/directions/:id/:style.:extension",
                    :styles => {
                        :'big' => {:geometry => "650x400#"},
                        :'small' => {:geometry => "130x80#"}
                    },
                    :convert_options => {
                      :'big' => '-quality 85',
                      :'small' => '-quality 85'
                    }

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
  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] },
    size: { in: 0..4.megabytes }

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
