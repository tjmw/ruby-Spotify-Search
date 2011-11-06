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

end
