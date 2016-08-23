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

