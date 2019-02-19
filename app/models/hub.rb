class Hub < ActiveRecord::Base
  class << self    
    def upload_data(unlocodes)
      transaction do
        import([:country_code, :locode, :name, :dia_name, :function, :status, :date, :iata, :lat, :lon], unlocodes, validate: false)
      end
    end
  end
end
