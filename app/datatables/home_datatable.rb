class HomeDatatable < ApplicationDatatable
  def_delegator :@view, :link_to
  def_delegator :@view, :search_path
  def_delegator :@view, :ti

  def view_columns
    @view_columns ||= {
      country_code: { source: "Hub.country_code", searchable: true, orderable: true },
      locode:       { source: "Hub.locode", searchable: true, orderable: true },
      name:         { source: "Hub.name", searchable: true, orderable: true },
      function:     { source: "Hub.function", searchable: true, orderable: true },
      status:       { source: "Hub.status", searchable: true, orderable: true },
      iata:         { source: "Hub.iata", searchable: true, orderable: true },
      lat:          { source: "Hub.lat", searchable: true, orderable: true },
      lon:          { source: "Hub.lon", searchable: true, orderable: true },
    }
  end
private
    def data
      records.map do |record|
        {
          country_code: record.country_code,
          locode: record.locode,
          name: record.name,
          function: record.function,
          status: record.status,
          iata: record.iata,
          lat: record.lat,
          lon: record.lon
        }
      end
    end

    def get_raw_records
      Hub.all
    end
end
