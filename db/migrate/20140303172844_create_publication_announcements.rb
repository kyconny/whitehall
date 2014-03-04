class CreatePublicationAnnouncements < ActiveRecord::Migration
  def change
    create_table :publication_announcements do |t|
      t.string      :title
      t.text        :summary
      t.datetime    :release_date
      t.string      :provisional_release_date
      t.references  :organisation
      t.references  :creator

      t.timestamps
    end

    add_index :publication_announcements, :organisation_id
    add_index :publication_announcements, :creator_id
  end
end
