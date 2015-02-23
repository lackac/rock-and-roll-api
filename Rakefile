require 'rake'
require 'sequel'
require_relative './config/initializer'

namespace :db do
  desc "Create tables"
  task :create_tables do
    DB.create_table :bands do
      primary_key :id
      String :name
      String :description, text: true
    end

    DB.create_table :songs do
      primary_key :id
      String  :title
      Integer :rating
      Integer :band_id
    end
  end

  desc "Drop tables"
  task :drop_tables do
    DB.run("drop table bands")
    DB.run("drop table songs")
  end

  desc "Reset database to initial state"
  task :reset => %i[drop_tables create_tables seed]

  desc "Insert sample bands and songs"
  task :seed do
    seed_data = {
      "Pearl Jam" => [
        { title: "Yellow Ledbetter", rating: 5 },
        { title: "Daughter", rating: 5 },
        { title: "Animal", rating: 4 },
        { title: "State of Love and Trust", rating: 4 },
        { title: "Alive", rating: 3 },
        { title: "Inside Job", rating: 4 }
      ],
      "Led Zeppelin" => [
        { title: "Black Dog", rating: 4 },
        { title: "Achilles Last Stand", rating: 5 },
        { title: "Immigrant Song", rating: 4 },
        { title: "Whole Lotta Love", rating: 4 }
      ],
      "Kaya Project" => [
        { title: "Always Waiting", rating: 5 }
      ],
      "Foo Fighters" => [
        { title: "The Pretender", rating: 3 },
        { title: "Best of You", rating: 5 }
      ],
      "Radiohead" => [
      ],
      "Red Hot Chili Peppers" => [
      ]
    }

    bands = DB[:bands]
    songs = DB[:songs]

    seed_data.each_pair do |band_name, songs_data|
      band = bands.where(name: band_name).first
      unless band
        puts "Create band: #{band_name}"
        band_id = bands.insert(name: band_name)
      end
      songs_data.each do |song_data|
        title = song_data[:title]
        rating = song_data[:rating]
        song = songs.where(title: title).first
        unless song
          puts "Create song: #{title} (#{rating})"
          song = songs.insert(title: title, rating: rating, band_id: band_id)
        end
      end
    end

    bands.where(name: "Pearl Jam").update(description: <<-EOS)
Pearl Jam is an American rock band, formed in Seattle, Washington,
in 1990, after the demise of Gossard and Ament's previous band,
Mother Love Bone. Pearl Jam broke into the mainstream with its
debut album, Ten, in 1991. One of the key bands of the grunge
movement in the early 1990s, over the course of the band's career,
its members became noted for their refusal to adhere to
traditional music industry practices, including refusing to make
music videos or give interviews and engaging in a much-publicized
boycott of Ticketmaster. In 2006, Rolling Stone described the band
as having "spent much of the past decade deliberately tearing
apart their own fame."
    EOS
  end

end

