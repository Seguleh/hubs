require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "Get index" do
    it "renders the index action" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "Get http 200" do
    it "gets 200 ok response from" do
      get :index
      expect(response.status).to eq(200)
    end
  end
  
  describe "File & data handling" do
    it "file opens" do
      
    end
    
    it "file is zip type" do
      
    end
    
    it "file data is read" do
      
    end
  end

end
