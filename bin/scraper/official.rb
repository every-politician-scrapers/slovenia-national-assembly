#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'open-uri/cached'
require 'pry'

class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      MemberList::Member::Name.new(
        full:     noko.css('a').text,
        prefixes: %w[mag dr]
      ).short
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.map { |member| fragment(member => Member) }.map(&:to_h).uniq
    end

    private

    def member_container
      noko.css('.pe-fluidgrid-item')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file, klass: Legislature::Members).csv
