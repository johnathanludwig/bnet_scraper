require 'bnet_scraper/starcraft2'
require 'faraday'
require 'nokogiri'

module BnetScraper
  class InvalidProfileError < Exception ; end
end
