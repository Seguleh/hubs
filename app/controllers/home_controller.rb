class HomeController < ApplicationController

  require 'rubygems'
  require 'zip'
  require 'csv'

  def index

  end

  # def load_data_external
  #   input = HTTParty.get("https://www.unece.org/fileadmin/DAM/cefact/locode/loc182csv.zip").body
  #   Zip::InputStream.open(StringIO.new(input)) do |files|
  #     data = []
  #     while file = files.get_next_entry
  #       if file.name.include?(".csv") && file.name.include?("UNLOCODE")
  #         csv = CSV.parse(files.read)
  #         csv.each do |row|
  #           if row[10].present?
  #             hash = {
  #               l1 = row[10].to_s.split(' ')[0]
  #               l2 = row[10].to_s.split(' ')[1]
  #               lat = l1.include?('N') ? (l1.tr('N','').to_f)/100 : -1*(l1.tr('S','').to_f)/100
  #               lon = l2.include?('E') ? (l2.tr('E','').to_f)/100 : -1*(l1.tr('W','').to_f)/100
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
  # end

  def load_data_local
    unless Hub.first.present?
      # Test for file open, test file is zip file
      Zip::File.open(Rails.public_path+'loc182csv.zip') do |files|
        data = []
        files.glob('*UNLOCODE*.csv') do |file|
          # Test for get_input_stream.read, contains string, contains parsable data
          csv = CSV.parse(file.get_input_stream.read)
          csv.each do |row|
            if row[10].present?
              l1 = row[10].to_s.split(' ')[0]
              l2 = row[10].to_s.split(' ')[1]
              lat = l1.include?('N') ? (l1.tr('N','').to_f)/100 : -1*(l1.tr('S','').to_f)/100
              lon = l2.include?('E') ? (l2.tr('E','').to_f)/100 : -1*(l1.tr('W','').to_f)/100
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
  end

end
