class ServicesAndInformationCollection
  attr_reader :title, :examples, :document_count, :subsector_link

  def initialize(params = {})
    @title = params.fetch(:title)
    @examples = params.fetch(:examples)
    @document_count = params.fetch(:document_count)
    @subsector_link = params.fetch(:subsector_link)
  end

  def to_partial_path
    "services_and_information/collection_group"
  end

  def self.build_collection_group_from(search_results)
    search_results.map { |content_group| self.new_collection_group_from(content_group) }
  end

  def self.new_collection_group_from(content_group)
    new(
      title: content_group[:value][:title],
      examples: content_group[:value][:examples],
      document_count: content_group[:documents],
      subsector_link: content_group[:value][:link],
    )
  end

  def title_for_example_at(index)
    examples[index][:title]
  end

  def link_for_example_at(index)
    examples[index][:link]
  end
end
