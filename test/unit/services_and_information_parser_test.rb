require "test_helper"

class ServicesAndInformationParserTest < ActiveSupport::TestCase
  test "#parse extracts content grouped by subsector from the passed in" do
    content = File.read(Rails.root.join("test", "fixtures", "services_and_info_fixture.json"))

    expected_parsed_content =
      [{ :documents=>7,
         :value=> {
          :slug=>"immigration-operational-guidance/asylum-policy",
          :link=>"/immigration-operational-guidance/asylum-policy",
          :title=>"Asylum policy",
          :parent_title=>"Immigration operational guidance",
          :examples=>[{:link=>"/a-document-about-asylum-policy", :title=>"A document about asylum policy"}]
        }
      }, {
        :documents=>4,
        :value=>
        { :slug=>"oil-and-gas/licensing",
          :link=>"/oil-and-gas/licensing",
          :title=>"Licensing",
          :parent_title=>"Oil and gas",
          :examples=>[] }
      }]

    parsed_content = ServicesAndInformationParser.new(content).parse

    assert_equal expected_parsed_content, parsed_content
  end
end
