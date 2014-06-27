class ServicesAndInformationFinder
  def initialize(organisation, search_client)
    @organisation = organisation
    @search_client = search_client
  end

  def find
    services_and_information_for_organisation
  end

private

  attr_reader :organisation, :search_client

  def services_and_information_for_organisation
    search_client.unified_search(search_query)
  end

  def search_query
    {
      q: organisation.name,
      filter_organisations: [organisation.name],
      facet_organisations: "100",
    }
  end
end
