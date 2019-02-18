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
end
