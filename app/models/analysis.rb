class Analysis < ActiveRecord::Base

  has_one :analysis_data,:dependent => :destroy

  has_attached_file :image,
                    :whiny => false,
                    :styles => { :thumb => ["72x72>"], :main => ["200x200>"] }

  validates_presence_of :name, :message => 'should be present.'
  
  validates_attachment_content_type :image, 
                                    :content_type => [ 'image/jpeg', 'image/pjpeg', 'image/png', 'image/x-png', 'image/gif'],
                                    :message => 'can only be jpeg, jpg, png, or gif'

  HUMANIZED_ATTRIBUTES = {
    :name => "Analysis name"
  }
  
  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end
  
end
