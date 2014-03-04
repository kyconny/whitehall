class Admin::PublicationAnnouncementsController < Admin::BaseController
  before_filter :find_publication_announcement, only: [:edit, :update, :destroy]

  def new
    @publication_announcement = build_announcement(organisation: current_user.organisation)
  end

  def create
    @publication_announcement = build_announcement(publication_announcement_params)

    if @publication_announcement.save
      redirect_to admin_root_url, notice: "Announcement saved successfully"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @publication_announcement.update_attributes(publication_announcement_params)
      redirect_to admin_root_url, notice: "Announcement updated successfully"
    else
      render :edit
    end
  end

  def destroy
    if @publication_announcement.destroy
      redirect_to admin_root_url, notice: "Announcement deleted successfully"
    else
      redirect_to admin_root_url, alert: "There was a problem deleting the announcement"
    end
  end

  private

  def find_publication_announcement
    @publication_announcement = PublicationAnnouncement.find(params[:id])
  end

  def build_announcement(attributes={})
    current_user.publication_announcements.new(attributes)
  end

  def publication_announcement_params
    params.require(:publication_announcement).permit(
      :title, :summary, :release_date, :provisional_release_date, :organisation_id
    )
  end
end
