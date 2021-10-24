#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/comparison'

REMAP = {
  party:        {
  },
  constituency: {
  },
}.freeze

CSV::Converters[:remap] = ->(val, field) { (REMAP[field.header] || {}).fetch(val, val) }

# Standardise data
class Comparison < EveryPoliticianScraper::Comparison
  def wikidata_csv_options
    { converters: [:remap] }
  end
end

diff = Comparison.new('wikidata/results/current-members.csv', 'data/official.csv').diff
puts diff.sort_by { |r| [r.first, r[1].to_s] }.reverse.map(&:to_csv)
