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
  
  describe "Get search" do
    it "renders the index action" do
      get :search
      expect(response).to render_template("search")
    end
  end

  describe "Get find" do
    it "renders the index action" do
      get :find
      expect(response).to render_template("find")
    end
  end

  describe "File & data handling" do
    it "should open file" do

    end

    it "should handle only zip file type" do

    end

    it "reads data correctly" do

    end

    it "converts data correctly" do
      
    end
  end

end
