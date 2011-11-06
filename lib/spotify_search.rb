require 'rubygems'
require 'net/http'
require 'uri'
require 'rexml/document'
require 'htmlentities'

# This module provides an interface to the Spotify metadata search API
#
# Author::    Tom Wey (tjmwey [at] gmail [dot] com)
# Copyright:: Copyright (c) 2011 Tom Wey
# License::   Distributes under the same terms as Ruby
#
# This product uses a SPOTIFY API but is not endorsed, certified or otherwise
# approved in any way by Spotify. Spotify is the registered trade mark of the
# Spotify Group.

module Spotify

    SEARCH_BASE_URL = 'http://ws.spotify.com/search/1' 

    # Spotify search parent class
    class Spotify::Search

        attr_reader :string
        attr_reader :results

        # Create a new Spotify search
        def initialize(search_string, page=1)
            @search_string = search_string
            @page          = page
            @results       = []
        end

        # Run our search
        def run
            results_xml = REXML::Document.new(
                Net::HTTP.get_response(search_url).body
            )

            parse_search_results(results_xml) 
        end

        private

        #--
        # Return the search URL
        #++
        def search_url
            # URI encode search string
            encoded_string = URI.encode(@search_string)

            URI.parse("#{search_url_base}?q=#{encoded_string}&page=#{@page}")
        end

    end

    # Spotify artist search
    class Spotify::Search::Artist < Spotify::Search

        private

        def search_url_base
            "#{SEARCH_BASE_URL}/artist"
        end

        def parse_search_results(xml)
            decoder = HTMLEntities.new

            xml.elements.each('//artists/artist') do |result|
                id   = decoder.decode(result.attribute('href'))
                name = decoder.decode(result.get_text('name'))

                @results << Spotify::Search::Result::Artist.new(
                    :id   => id,
                    :name => name
                )
            end
        end

    end

    # Spotify album search
    class Spotify::Search::Album < Spotify::Search

        private

        def search_url_base
            "#{SEARCH_BASE_URL}/album"
        end

        def parse_search_results(xml)
            decoder = HTMLEntities.new

            xml.elements.each('//albums/album') do |result|
                id     = decoder.decode(result.attribute('href'))
                name   = decoder.decode(result.get_text('name'))
                artist = decoder.decode(result.get_text('artist/name'))

                @results << Spotify::Search::Result::Album.new(
                    :id     => id,
                    :name   => name,
                    :artist => artist
                )
            end
        end

    end

    # Spotify track search
    class Spotify::Search::Track < Spotify::Search

        private

        def search_url_base
            "#{SEARCH_BASE_URL}/track"
        end

        def parse_search_results(xml)
            decoder = HTMLEntities.new

            xml.elements.each('//tracks/track') do |result|
                id     = decoder.decode(result.attribute('href'))
                name   = decoder.decode(result.get_text('name'))
                artist = decoder.decode(result.get_text('artist/name'))
                album  = decoder.decode(result.get_text('album/name'))

                @results << Spotify::Search::Result::Track.new(
                    :id     => id,
                    :name   => name,
                    :artist => artist,
                    :album  => album
                )
            end
        end

    end

    # Spotify search result parent class
    class Spotify::Search::Result

        attr_reader :id
        attr_reader :name

        def initialize(args)
            @id   = args[:id] 
            @name = args[:name] 
        end

    end

    # Spotify artist search result
    class Spotify::Search::Result::Artist < Spotify::Search::Result

    end

    # Spotify album search result
    class Spotify::Search::Result::Album < Spotify::Search::Result

        attr_reader :artist

        def initialize(args)
            super
            @artist = args[:artist] 
        end

    end

    # Spotify track search result
    class Spotify::Search::Result::Track < Spotify::Search::Result

        attr_reader :artist
        attr_reader :album

        def initialize(args)
            super
            @artist = args[:artist] 
            @album = args[:album] 
        end

    end

end
