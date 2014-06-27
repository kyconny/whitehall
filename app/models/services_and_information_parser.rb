class ServicesAndInformationParser
  def initialize(content)
    @content = content
  end

  def parse
    subsectors_with_examples
  end

private

  attr_reader :content

  def subsectors_with_examples
    content_groups
  end

  def content_groups
    specialist_sectors[:options]
  end

  def specialist_sectors
    groupings[:facets][:specialist_sectors]
  end

  def groupings
    JSON.parse(content, symbolize_names: true)
  end
end
