class HomeController < ApplicationController

  require 'zip'
  require 'csv'

  def index
  end

  def load_data_external
    # Preventive code to avoid bandwidth consumption
    unless Hub.first.present?
      # Hardcoding it to the url with the file but a more decent code would be made to
      # accept a link or filename with certain conditions (user input, file size validations, certain regex, etc)
      # TODO Test for file open, test file is zip file
      input = HTTParty.get("https://www.unece.org/fileadmin/DAM/cefact/locode/loc182csv.zip").body
      # TODO Test for get_input_stream.read, contains string, contains parsable data
      Zip::InputStream.open(StringIO.new(input)) do |files|
        data = []
        while file = files.get_next_entry
          if file.name.include?(".csv") && file.name.include?("UNLOCODE")
            csv = CSV.parse(files.read)
            csv.each do |row|
              if row[10].present?
                # Split the coordinates
                l1 = row[10].to_s.split(' ')[0]
                l2 = row[10].to_s.split(' ')[1]
                # Convert to lat-lon coordinates format
                # Done taking into consideration the given format: lat -> ddmm and lon-> dddmm
                # from the UN manual pdf where the last two are ALWAYS mm
                # TODO Test for format consistency and decimal latlon result as expected
                lat = l1.include?('N') ? (l1.tr('N','').first(2).to_f+(l1.tr('N','').last(2).to_f)/60) : -1*((l1.tr('S','').first(2).to_f+(l1.tr('S','').last(2).to_f)/60))
                lon = l2.include?('E') ? (l2.tr('E','').first(3).to_f+(l2.tr('E','').last(2).to_f)/60) : -1*((l2.tr('W','').first(3).to_f+(l2.tr('W','').last(2).to_f)/60))
                hash = {
                  country_code: row[1],
                  locode: row[2],
                  # Database compatibility encoding
                  # TODO Test enconding is working as expected
                  name: row[3].force_encoding('iso-8859-1').encode('utf-8'),
                  dia_name: row[4],
                  function: row[6],
                  status: row[7],
                  date: row[8],
                  iata: row[9],
                  lat: lat,
                  lon: lon
                }
                data << hash
              end
            end
            Hub.upload_data(data)
          end
        end
      end
    end
    render json: {status: 'Finished'}
  end

  # # Made this to test locally and save time downloading from url
  # def load_data_local
  #   unless Hub.first.present?
  #     Zip::File.open(Rails.public_path+'loc182csv.zip') do |files|
  #       data = []
  #       files.glob('*UNLOCODE*.csv') do |file|
  #         csv = CSV.parse(file.get_input_stream.read)
  #         csv.each do |row|
  #           if row[10].present?
  #             l1 = row[10].to_s.split(' ')[0]
  #             l2 = row[10].to_s.split(' ')[1]
  #             lat = l1.include?('N') ? (l1.tr('N','').first(2).to_f+(l1.tr('N','').last(2).to_f)/60) : -1*((l1.tr('S','').first(2).to_f+(l1.tr('S','').last(2).to_f)/60))
  #             lon = l2.include?('E') ? (l2.tr('E','').first(3).to_f+(l2.tr('E','').last(2).to_f)/60) : -1*((l2.tr('W','').first(3).to_f+(l2.tr('W','').last(2).to_f)/60))
  #             hash = {
  #               country_code: row[1],
  #               locode: row[2],
  #               name: row[3].force_encoding('iso-8859-1').encode('utf-8'),
  #               dia_name: row[4],
  #               function: row[6],
  #               status: row[7],
  #               date: row[8],
  #               iata: row[9],
  #               lat: lat,
  #               lon: lon
  #             }
  #             data << hash
  #           end
  #         end
  #         Hub.upload_data(data)
  #       end
  #     end
  #   end
  #   render json: {status: 'Finished'}
  # end

  def search
    respond_to do |format|
      format.html
      format.json { render json: HomeDatatable.new(params, view_context: view_context) }
    end
  end

  def find
  end

  def find_nearest
    # No reason to run this code if there is no data loaded
    unless Hub.first.present?
      query = {
        'address': params['address'],
        'key': 'AIzaSyAp29CPfDeUOLveRJstFBGldd-es4-FTnc',
      }
      # Didn't do the API call directly on the JS file with ajax to secure a bit more the API key, not let it be visible just to be safe
      # (even though I also made some IP restrictions from the google cloud console)
      # Otherwise would've been a faster response on the marker appearing on the map almost instantly after the search call
      response = HTTParty.get('https://maps.googleapis.com/maps/api/geocode/json', query: query)
      formatted = response.parsed_response
      lat = formatted['results'][0]['geometry']['location']['lat']
      lng = formatted['results'][0]['geometry']['location']['lng']

      # No need to gather all of the Hubs, a big enough range will give a high probability of one nearby and thus improve performance by factoring probability
      # This would need be researched further to provide a best-probabilty range and not just 6 degrees lat-lng difference from search point,
      # which I just semi-researched as a more-than-enough range by countries area in km and distribution of hubs
      # considering 6 degrees latitude are more than 600km up and 600km down from origin and longitude is a bit tricky
      locations = Hub.where(lat: lat-3..lat+3, lon: lng-3..lng+3)
      if locations.present?
        coordinates = locations.pluck(:lat, :lon, :id)
        array = []
        # Was planning on using geokit or geocoder gems but I think this works, not as efficient as the gems I think
        coordinates.each do |crd|
          array << [distance([lat,lng], [crd[0], crd[1]]), crd[0], crd[1], crd[2]]
        end
        nrst = array.sort.first
        hub = Hub.find(nrst[3])

        render json: {result: formatted['results'], status: formatted['status'], nearest: nrst, info: hub}
      else
        render json: {status: 0}
      end
    end
    render json: {status: 0}
  end

  # Haversine formula code from https://stackoverflow.com/a/12969617
  def distance(loc1, loc2)
    rad_per_deg = Math::PI/180
    rkm = 6371
    rm = rkm * 1000

    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c
  end

end
