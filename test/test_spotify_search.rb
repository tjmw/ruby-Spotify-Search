require 'helper'
require 'spotify_search'

# TODO: Write some kind of meaningful tests :-)

class TestSpotifySearch < Test::Unit::TestCase

    def test_artist_search
        search = Spotify::Search::Artist.new('Neil Young')
        assert_equal 1, search.page
        assert_equal 'Neil Young', search.search_string
        assert_equal [], search.results

        search = Spotify::Search::Artist.new('Neil Young', 2)
        assert_equal 2, search.page
    end

    def test_track_search
        search = Spotify::Search::Track.new('Heart of Gold')
        assert_equal 1, search.page
        assert_equal 'Heart of Gold', search.search_string
        assert_equal [], search.results
    end

    def test_album_search
        search = Spotify::Search::Album.new('Harvest')
        assert_equal 1, search.page
        assert_equal 'Harvest', search.search_string
        assert_equal [], search.results
    end

    def test_album_link
        album = Spotify::Search::Result::Album.new(
            :uri    => 'spotify:album:4ln0tQzp4XX6o2Z8XIlVDk',
            :name   => 'The Age of Adz',
            :artist => 'Sufjan Stevens'
        )

        assert_equal 'http://open.spotify.com/album/4ln0tQzp4XX6o2Z8XIlVDk', album.link
    end

    def test_track_link
        track = Spotify::Search::Result::Track.new(
            :uri    => 'spotify:track:3AA7xE2crhkwdUMwsdiAk1',
            :name   => 'Impossible Soul',
            :album  => 'The Age of Adz',
            :artist => 'Sufjan Stevens'
        )

        assert_equal 'http://open.spotify.com/track/3AA7xE2crhkwdUMwsdiAk1', track.link
    end

    def test_artist_link
        artist = Spotify::Search::Result::Artist.new(
            :uri  => 'spotify:artist:4MXUO7sVCaFgFjoTI5ox5c',
            :name => 'Sufjan Stevens'
        )

        assert_equal 'http://open.spotify.com/artist/4MXUO7sVCaFgFjoTI5ox5c', artist.link
    end
end
