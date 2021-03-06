THE_DOCUMENT = Transform(/the (document|publication|policy|news article|consultation|consultation response|speech|worldwide priority|detailed guide|announcement|world location news article|statistical data set|supporting page|document collection|corporate information page) "([^"]*)"/) do |document_type, title|
  document_class(document_type).latest_edition.find_by_title!(title)
end

module DocumentHelper
  def document_class(type)
    type = 'edition' if type == 'document'
    type.gsub(" ", "_").classify.constantize
  end

  def set_lead_organisation_on_document(organisation, order = 1)
    select organisation.name, from: "edition_lead_organisation_ids_#{order}"
  end

  def begin_drafting_document(options)
    if Organisation.count == 0
      create(:organisation)
    end
    if Topic.count == 0
      create(:topic)
    end
    visit admin_root_path
    # Make sure the dropdown is visible first, otherwise Capybara won't see the links
    find('li.create-new a', text: 'New document').click
    within 'li.create-new' do
      click_link options[:type].humanize
    end

    within 'form' do
      fill_in "edition_title", with: options[:title]
      fill_in "edition_body", with: options.fetch(:body, "Any old iron")
      fill_in "edition_summary", with: options.fetch(:summary, 'one plus one euals two!')
      fill_in_change_note_if_required
      select_topic_if_required unless options[:skip_topic_selection]

      unless options[:type] == 'world_location_news_article'
        set_lead_organisation_on_document(Organisation.first)
      end

      if options[:alternative_format_provider]
        select options[:alternative_format_provider].name, from: "edition_alternative_format_provider_id"
      end
      if options[:primary_mainstream_category]
        select options[:primary_mainstream_category].title, from: "Primary detailed guidance category"
      end
    end
  end

  def begin_drafting_policy(options)
    begin_drafting_document(options.merge(type: "policy", summary: options[:summary] || "Policy summary"))
  end

  def begin_editing_document(title)
    visit_edition_admin title
    click_link "Edit draft"
  end

  def begin_new_draft_document(title)
    visit_edition_admin title
    click_button "Create new edition to edit"
  end

  def begin_drafting_news_article(options)
    begin_drafting_document(options.merge(type: "news_article"))
    fill_in_news_article_fields(options.slice(:first_published, :announcement_type))
  end

  def begin_drafting_consultation(options)
    begin_drafting_document(options.merge(type: "consultation"))
    select_date 10.days.from_now.to_s, from: "Opening Date"
    select_date 40.days.from_now.to_s, from: "Closing Date"
  end

  def begin_drafting_world_location_news_article(options)
    begin_drafting_document(options.merge(type: "world_location_news_article"))
  end

  def begin_drafting_publication(title, options = {})
    policy = create(:policy)
    begin_drafting_document type: 'publication', title: title, summary: "Some summary of the content", alternative_format_provider: create(:alternative_format_provider)
    fill_in_publication_fields(options)
    select policy.title, from: "Related policies"
  end

  def begin_drafting_statistical_data_set(options)
    begin_drafting_document options.merge(type: 'statistical_data_set')
  end

  def begin_drafting_speech(options)
    organisation = create(:ministerial_department)
    person = create_person("Colonel Mustard")
    role = create(:ministerial_role, name: "Attorney General", organisations: [organisation])
    role_appointment = create(:role_appointment, person: person, role: role, started_at: Date.parse('2010-01-01'))
    speech_type = SpeechType::Transcript
    begin_drafting_document options.merge(type: 'speech', summary: "Some summary of the content")
    select speech_type.singular_name, from: "Speech type"
    select "Colonel Mustard, Attorney General", from: "Speaker"
    select_date 1.day.ago.to_s, from: "Delivered on"
    fill_in "Location", with: "The Drawing Room"
  end

  def begin_drafting_document_collection(options)
    begin_drafting_document options.merge(type: 'document_collection')
  end

  def pdf_attachment
    Rails.root.join('features/fixtures/attachment.pdf')
  end

  def fill_in_news_article_fields(first_published: "2010-01-01", announcement_type: "News story")
    select announcement_type, from: "News article type"
    select_date first_published, from: "First published"
  end

  def fill_in_publication_fields(first_published: "2010-01-01", publication_type: "Research and analysis")
    select_date first_published, from: "First published"
    select publication_type, from: "edition_publication_type_id"
    check "This publication is held on another website"
    fill_in "External link URL", with: "http://example.com/publication"
  end

  def visit_edition_admin(title, scope = :scoped)
    document = Edition.send(scope).find_by_title(title)
    visit admin_edition_path(document)
  end

  def visit_document_preview(title, scope = :scoped)
    document = Edition.send(scope).find_by_title(title)
    visit preview_document_path(document)
  end

  def fill_in_change_note_if_required
    if has_css?("textarea[name='edition[change_note]']")
      fill_in "edition_change_note", with: "changes"
    end
  end

  def select_topic_if_required
    if has_css?(".edition-topic-fields")
      within(".edition-topic-fields") do
        select Topic.first.name, from: "Topics"
      end
    end
  end

  def refute_flash_alerts_exist
    assert has_no_css?(".flash.alert")
  end

  def publish(options = {})
    if options[:force]
      click_link "Force publish"
      page.has_css?("#forcePublishModal", visible: true)
      within '#forcePublishModal' do
        fill_in 'reason', with: "because"
        click_button 'Force publish'
      end
      unless options[:ignore_errors]
        refute_flash_alerts_exist
      end
    else
      click_button "Publish"
      unless options[:ignore_errors]
        refute_flash_alerts_exist
      end
    end
  end

  def speed_tag_publication(title)
    edition = Edition.find_by_title(title)
    visit admin_edition_path(edition)

    assert page.has_css?('.speed-tag')
    within '.speed-tag' do
      select 'Research and analysis', from: 'Publication type'
      click_on 'Save'
      assert page.has_no_css?('.speed-tag .alert')
    end
  end

  def convert_to_draft(title)
    edition = Edition.find_by_title(title)
    visit admin_edition_path(edition)

    click_on 'Convert to draft'
    assert page.has_no_css?('.speed-tag')
  end
end

World(DocumentHelper)
