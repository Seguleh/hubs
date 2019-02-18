class HomeController < ApplicationController
  
  require 'rubygems'
  require 'zip'
  require 'csv'

  def index
    input = HTTParty.get("https://www.unece.org/fileadmin/DAM/cefact/locode/loc182csv.zip").body

    Zip::InputStream.open(StringIO.new(input)) do |files|
      while file = files.get_next_entry
        if file.name.include?(".csv") && file.name.include?("UNLOCODE")
          csv = CSV.parse(io.read)
          csv.each do |x|
            puts x
          end
        end
      end
    end
  end

end
