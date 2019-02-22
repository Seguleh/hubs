require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "Get index" do
    it "renders the index view" do
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
    it "renders the search view" do
      get :search
      expect(response).to render_template("search")
    end
  end

  describe "Get find" do
    it "renders the find view" do
      get :find
      expect(response).to render_template("find")
    end
  end

  let(:buffer) {StringIO.new}
  let(:zip) {Rails.root.to_s + "/spec/fixtures/files/file.zip"}

  describe "File & data handling" do
    it "should open the file correctly" do
      File.open(zip) do |f|
        expect(f).to be_a File
      end
    end

    it "should recieve data from file" do
      allow(File).to receive(:open).with(zip, 'wb').and_yield(buffer)
    end

    it "should not accept empty files" do
      expect(File.size(zip)).to be > 0
    end

    it "should only be zip file type" do
      type = MIME::Types.type_for(zip).first.content_type
      expect(type).to eq("application/zip")
    end

    it "reads at least some data from the file" do
      expect(File.read(zip)).not_to be_nil
    end
  end
end
