require 'bnet_scraper/starcraft2/base_scraper'
require 'bnet_scraper/starcraft2/profile_scraper'
require 'bnet_scraper/starcraft2/league_scraper'
require 'bnet_scraper/starcraft2/achievement_scraper'
require 'bnet_scraper/starcraft2/match_history_scraper'
require 'bnet_scraper/starcraft2/status_scraper'
require 'bnet_scraper/starcraft2/grandmaster_scraper'

module BnetScraper
  # This module contains everything about scraping Starcraft 2 Battle.net accounts.
  # See `BnetScraper::Starcraft2::ProfileScraper` and `BnetScraper::Starcraft2::LeagueScraper`
  # for more details
  module Starcraft2
    REGIONS = {
      'na'  => { domain: 'us.battle.net', dir: 'en', label: 'North America' },
      'eu'  => { domain: 'eu.battle.net', dir: 'en', label: 'Europe' },
      'cn'  => { domain: 'www.battlenet.com.cn', dir: 'zh', label: 'China' },
      'sea' => { domain: 'sea.battle.net', dir: 'en', label: 'South-East Asia' },
      'fea' => { domain: 'tw.battle.net', dir: 'zh', label: 'Korea' }
    }

    REGION_DOMAINS = {
      'us.battle.net' => 'na',
      'eu.battle.net' => 'eu',
      'www.battlenet.com.cn' => 'cn',
      'sea.battle.net' => 'sea',
      'kr.battle.net' => 'fea',
      'tw.battle.net' => 'fea'
    }

    # This is a convenience method that chains calls to ProfileScraper,
    # followed by a scrape of each league returned in the `leagues` array
    # in the profile_data.  The end result is a fully scraped profile with
    # profile and league data in a hash.
    #
    # See `BnetScraper::Starcraft2::ProfileScraper` for more information on
    # the parameters being sent to `#full_profile_scrape`.
    #
    # @param options - Hash of profile options (url, bnet_id/account/region, etc).  See 
    #   `BnetScraper::Starcraft::BaseScraper` for more information on hash options.
    # @return [BnetScraper::Profile] profile_data - Profile object containing complete profile and league data
    def self.full_profile_scrape options = {}
      profile_scraper = ProfileScraper.new options
      profile = profile_scraper.scrape
      profile.leagues.each do |league|
        league.scrape
      end
      profile.achievements
      profile.match_history
      
      return profile
    end

    # Determine if Supplied profile is valid.  Useful for validating now before an 
    # async scraping later
    #
    # @param [Hash] options - account information hash
    # @return [TrueClass, FalseClass] valid - whether account is valid
    def self.valid_profile? options
      scraper = BaseScraper.new(options)
      scraper.valid?
    end
  end
end
