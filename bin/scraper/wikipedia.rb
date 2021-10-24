#!/bin/env ruby
# frozen_string_literal: true

require 'csv'
require 'pry'
require 'scraped'
require 'wikidata_ids_decorator'

require 'open-uri/cached'

class RemoveReferences < Scraped::Response::Decorator
  def body
    Nokogiri::HTML(super).tap do |doc|
      doc.css('sup.reference').remove
    end.to_s
  end
end

class MembersPage < Scraped::HTML
  decorator RemoveReferences
  decorator WikidataIdsDecorator::Links

  field :members do
    member_rows.map { |ul| fragment(ul => Member).to_h }
  end

  private

  def member_rows
    uls.flat_map { |ul| ul.xpath('.//li[a]') }
  end

  def uls
    noko.xpath('//h2[contains(.,"Viri")]/following::*').remove
    noko.xpath('//h2[contains(.,"Poslanci")]/following::ul')
  end
end

class Member < Scraped::HTML
  field :item do
    name_link.attr('wikidata')
  end

  field :name do
    name_link.text.tidy
  end

  private

  def name_link
    noko.css('a')
  end
end

url = 'https://sl.wikipedia.org/wiki/Seznam_poslancev_8._Dr%C5%BEavnega_zbora_Republike_Slovenije'
data = MembersPage.new(response: Scraped::Request.new(url: url).response).members

header = data.first.keys.to_csv
rows = data.map { |row| row.values.to_csv }
abort 'No results' if rows.count.zero?

puts header + rows.join
