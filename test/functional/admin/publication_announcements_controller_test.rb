require 'test_helper'

class Admin::PublicationAnnouncementsControllerTest < ActionController::TestCase
  setup do
    @user = login_as(:policy_writer)
    @organisation = create(:organisation)
  end

  view_test "GET :new renders a new publication announcement form" do
    get :new

    assert_response :success
    assert_select "input[name='publication_announcement[title]']"
  end

  test "POST :create saves the publication announcement to the database and redirects to the dashboard" do
    post :create, publication_announcement: {
                    title: 'Beard stats 2014',
                    summary: 'Summary text',
                    release_date: 1.year.from_now,
                    organisation_id: @organisation.id }

    assert_redirected_to admin_root_url
    assert announcement = PublicationAnnouncement.last
    assert_equal 'Beard stats 2014', announcement.title
    assert_equal @organisation, announcement.organisation
    assert_equal @user, announcement.creator
  end

  view_test "POST :create re-renders the form if the announcement is invalid" do
    post :create, publication_announcement: { title: '', summary: 'Summary text' }

    assert_response :success
    assert_select "ul.errors li", text: "Title can&#x27;t be blank"
    refute PublicationAnnouncement.any?
  end

  view_test "GET :edit renders edit form for publication announcement" do
    announcement = create(:publication_announcement)
    get :edit, id: announcement.id

    assert_response :success
    assert_select "input[name='publication_announcement[title]'][value='#{announcement.title}']"
  end

  test "PUT :update saves changes to the announcement" do
    announcement = create(:publication_announcement)
    put :update, id: announcement.id, publication_announcement: { title: "New announcement title" }

    assert_redirected_to admin_root_url
    assert_equal 'New announcement title', announcement.reload.title
  end

  view_test "PUT :update re-renders edit form if changes are not valid" do
    announcement = create(:publication_announcement)
    put :update, id: announcement.id, publication_announcement: { title: '' }

    assert_response :success
    assert_select "ul.errors li", text: "Title can&#x27;t be blank"
  end

  test "DELETE :destroy deletes the announcement" do
    announcement = create(:publication_announcement)
    delete :destroy, id: announcement.id

    assert_redirected_to admin_root_url
    refute PublicationAnnouncement.exists?(announcement)
    assert_equal "Announcement deleted successfully", flash[:notice]
  end
end
