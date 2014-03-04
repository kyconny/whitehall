
When(/^I make an announcement for a statistical publication called "([^"]*)"$/) do |title|
  ensure_path admin_root_path
  organisation = Organisation.first || create(:organisation)

  click_on "New statistics announcement"
  fill_in :publication_announcement_title, with: title
  fill_in :publication_announcement_summary, with: "Summary of publication"
  select_date 1.year.from_now.to_s, from: "Expected release date"
  select organisation.name, from: :publication_announcement_organisation_id
  click_on 'Save announcement'
end

Then(/^I should see the announcement for "([^"]*)" on my dashboard$/) do |title|
  assert annoucement = PublicationAnnouncement.find_by_title(title)
  ensure_path admin_root_path

  assert page.has_content? title
end

