# !!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!
# THIS IS NO LONGER USED
# !!!!!!!!!!!!!!!!!!!!!!!!!!
# !!!!!!!!!!!!!!!!!!!!!!!!!!

# == Schema Information
#
# Table name: direction_images
#
#  id                 :integer          not null, primary key
#  direction_id       :integer
#  sort_order         :integer          default(1)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#

class DirectionImage < ActiveRecord::Base
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
  ## RELATIONSHIPS
  belongs_to :directions

  #######################
  ## VALIDATIONS

  validates_attachment :image,
    content_type: { content_type: ["image/jpeg", "image/png", "image/gif"] },
    size: { in: 0..4.megabytes }

  #######################
  ## SCOPES
  scope :sorted, -> { order(:sort_order) }

end

