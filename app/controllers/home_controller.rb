class HomeController < ApplicationController

  require 'rubygems'
  require 'zip'
  require 'csv'

  def index
  end

  # def load_data_external
  #   # Preventive code to avoid bandwidth consumption
  #   unless Hub.first.present?
  #     # Hardcoding it to the url with the file but a more decent code would be made to
  #     # accept a link or filename with certain conditions (user input, file size validations, certain regex, etc)
  #     # TODO Test for file open, test file is zip file
  #     input = HTTParty.get("https://www.unece.org/fileadmin/DAM/cefact/locode/loc182csv.zip").body
  #     # TODO Test for get_input_stream.read, contains string, contains parsable data
  #     Zip::InputStream.open(StringIO.new(input)) do |files|
  #       data = []
  #       while file = files.get_next_entry
  #         if file.name.include?(".csv") && file.name.include?("UNLOCODE")
  #           csv = CSV.parse(files.read)
  #           csv.each do |row|
  #             if row[10].present?
  #               hash = {
  #                 # Split the coordinates
  #                 l1 = row[10].to_s.split(' ')[0]
  #                 l2 = row[10].to_s.split(' ')[1]
  #                 # Convert to lat-lon coordinates format
  #                 # Done taking into consideration the given format: lat -> ddmm and lon-> dddmm
  #                 # from the UN manual pdf where the last two are ALWAYS mm
  #                 # TODO Test for format consistency and decimal latlon result as expected
  #                 lat = l1.include?('N') ? (l1.tr('N','').first(2).to_f+(l1.tr('N','').last(2).to_f)/60) : -1*((l1.tr('S','').first(2).to_f+(l1.tr('S','').last(2).to_f)/60))
  #                 lon = l2.include?('E') ? (l2.tr('E','').first(3).to_f+(l2.tr('E','').last(2).to_f)/60) : -1*((l2.tr('W','').first(3).to_f+(l2.tr('W','').last(2).to_f)/60))
  #                 country_code: row[1],
  #                 locode: row[2],
  #                 # Database compatibility encoding
  #                 # TODO Test enconding is working as expected
  #                 name: row[3].force_encoding('iso-8859-1').encode('utf-8'),
  #                 dia_name: row[4],
  #                 function: row[6],
  #                 status: row[7],
  #                 date: row[8],
  #                 iata: row[9],
  #                 lat: lat,
  #                 lon: lon
  #               }
  #               data << hash
  #             end
  #           end
  #           Hub.upload_data(data)
  #         end
  #       end
  #     end
  #   end
  #   # TODO Database already loaded response
  # end

  # Made this to test locally and save time from downloading from url
  def load_data_local
    unless Hub.first.present?
      Zip::File.open(Rails.public_path+'loc182csv.zip') do |files|
        data = []
        files.glob('*UNLOCODE*.csv') do |file|
          csv = CSV.parse(file.get_input_stream.read)
          csv.each do |row|
            if row[10].present?
              l1 = row[10].to_s.split(' ')[0]
              l2 = row[10].to_s.split(' ')[1]
              lat = l1.include?('N') ? (l1.tr('N','').first(2).to_f+(l1.tr('N','').last(2).to_f)/60) : -1*((l1.tr('S','').first(2).to_f+(l1.tr('S','').last(2).to_f)/60))
              lon = l2.include?('E') ? (l2.tr('E','').first(3).to_f+(l2.tr('E','').last(2).to_f)/60) : -1*((l2.tr('W','').first(3).to_f+(l2.tr('W','').last(2).to_f)/60))
              hash = {
                country_code: row[1],
                locode: row[2],
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
    render json: {status: 'Finished'}
  end

  def search
    respond_to do |format|
      format.html
      format.json { render json: HomeDatatable.new(params, view_context: view_context) }
    end
  end

  def find
  end

  def find_nearest
  end

end
