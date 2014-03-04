class PublicationAnnouncement < ActiveRecord::Base
  belongs_to :organisation
  belongs_to :creator, class_name: 'User'

  validates :title, :summary, :release_date, :creator, :organisation, presence: true
end
