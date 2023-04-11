require "spec_helper"
require "rack/test"
require_relative '../../app'

# For a later challenge, see if I can refactor below with variables and loops

def reset_albums_table
  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table
  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }
  before(:each) do
    reset_albums_table
    reset_artists_table
  end

  context "POST /albums" do
    it "returns 200 OK and expected results with /GET" do
      response = post('/albums', title: 'Voyage', release_year: '2022', artist_id: '2')
      expect(response.status).to eq (200)
      response2 = get('/albums')
      expect(response2.body).to include('Voyage')
    end
  end

  # context "GET /albums" do
  #   it "returns the albums" do
  #     response = get('/albums')
  #     expect(response.status).to eq (200)
  #     result = "Doolittle, Surfer Rosa, Waterloo, Super Trouper, Bossanova, Lover, Folklore, I Put a Spell on You, Baltimore, Here Comes the Sun, Fodder on My Wings, Ring Ring"
  #     expect(response.body).to eq result
  #   end
  # end

  context 'GET /albums' do
    it "returns the albums html" do
      response = get('/albums')
      expect(response.status).to eq 200
      expect(response.body).to include('Title: Doolittle')
      expect(response.body).to include('Title: Folklore')
    end

    it "returns a hyperlink to the /album/:id for each album" do
      response = get('/albums')
      expect(response.status).to eq 200
      # expect(response.body).to include('/albums/1')
      expect(response.body).to include('<a href="/albums/1">Go to the album link</a>')
    end
  end


  context 'GET /artists' do
    it "returns the artists" do
      response = get('/artists')
      expect(response.status).to eq (200)
      expect(response.body).to eq 'Pixies, ABBA, Taylor Swift, Nina Simone'
    end
  end

  context 'POST /artists' do
    it 'status is 200 OK, adds artist and returns artist included in list with /GET' do
      response = post('/artists', name: 'Wild nothing', genre: 'Indie')
      expect(response.status).to eq 200
      # note: the body will return empty
      # expect(response.body).to eq ''
      response = get('/artists')
      expect(response.body).to include('Wild nothing')
    end
  end

  context 'GET /albums/:id' do
    it 'returns the specified album info for id = 1' do
      response = get('/albums/1')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include("Release year: 1989")
      expect(response.body).to include('Artist: Pixies')
    end

    it 'returns the specified album info for id = 2' do
      response = get('/albums/2')
      expect(response.status).to eq 200
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include("Release year: 1988")
      expect(response.body).to include('Artist: Pixies')
    end
  end
end
