require 'test_helper'

class Edition::SpecialistSectorsTest < ActiveSupport::TestCase
  test '#create_draft should copy specialist sectors' do
    expected_primary_tag = 'tax/vat'
    expected_secondary_tags = ['oil-and-gas/taxation', 'tax/corporation-tax']
    edition = create(:published_policy, primary_specialist_sector_tag: expected_primary_tag, secondary_specialist_sector_tags: expected_secondary_tags)

    draft = edition.create_draft(create(:policy_writer))

    assert_equal expected_primary_tag, draft.primary_specialist_sector_tag
    assert_equal expected_secondary_tags, draft.secondary_specialist_sector_tags
  end

  test "#specialist_sector_tags should return tags ordered from primary to secondary" do
    expected_primary_tag = 'tax/vat'
    expected_secondary_tags = ['oil-and-gas/taxation', 'tax/corporation-tax']

    edition = create(
      :published_edition,
      title: "edition-title",
      primary_specialist_sector_tag: expected_primary_tag,
      secondary_specialist_sector_tags: expected_secondary_tags,
    )

    assert_equal(
      [expected_primary_tag, expected_secondary_tags].flatten,
      edition.specialist_sector_tags
    )
  end

  test "#specialist_sector_tags should return an empty array for editions without specialist sectors" do
    edition_without_specialist_sectors = create(
      :edition,
      primary_specialist_sector_tag: nil,
      secondary_specialist_sector_tags: [],
    )

    assert_equal [], edition_without_specialist_sectors.specialist_sector_tags
  end
end
