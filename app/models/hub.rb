class Hub < ActiveRecord::Base
  # Validations all done on the database side to optimize transaction speed
  class << self    
    def upload_data(unlocodes)
      transaction do
        import([:country_code, :locode, :name, :dia_name, :function, :status, :date, :iata, :lat, :lon], unlocodes, validate: false)
      end
    end
  end
end
