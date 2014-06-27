require "test_helper"

class ServicesAndInformationCollectionTest < ActiveSupport::TestCase
  test ".build_collection_group_from creates an array of collections" do
    search_results = [{
      documents: 1,
      value: {
        title: "Example subsector",
        link: "/example-subsector",
        examples: [
          { title: "A document title", link: "/a-document-link"},
        ]
      }
    }]

    collection = ServicesAndInformationCollection.build_collection_group_from(search_results)

    assert_equal 1, collection.length
    assert_equal "Example subsector", collection[0].title
  end

  test "#title_for_example_at" do
    collection = ServicesAndInformationCollection.new(
      title: "Example subsector",
      subsector_link: "/example-subsector",
      examples: [ { title: "Example document", link: "/example-document" } ],
      document_count: 1
    )

    assert_equal "Example document", collection.title_for_example_at(0)
  end

  test "#link_for_example_at" do
    collection = ServicesAndInformationCollection.new(
      title: "Example subsector",
      subsector_link: "/example-subsector",
      examples: [ { title: "Example document", link: "/example-document" } ],
      document_count: 1
    )

    assert_equal "/example-document", collection.link_for_example_at(0)
  end
end
