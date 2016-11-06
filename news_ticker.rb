require 'nokogiri'
require 'net/http'
# require 'uri'

class Page
  attr_reader :url, :element_path, :raw_page_nokogiri, :headlines

  def initialize(url)
    @url = url
    # @element_path = element_path
    raw_page = Net::HTTP.get(URI.parse(url))
    @raw_page_nokogiri = Nokogiri::HTML(raw_page)
    @headlines = Array.new
  end

  def get_headlines_text(element_path)
    @element_path = element_path
    headline_length = @raw_page_nokogiri.css(@element_path).count
    i = 0
    until i == headline_length
      @headlines.push(@raw_page_nokogiri.css(@element_path)[i].text)
      i += 1
    end
    @headlines
  end

  def print_headlines
    puts "\nHere's the news from #{url}:\n" + "-"*50
    @headlines.each_with_index do | headline, index |
      puts "Item #{index+1}: #{headline}"
      sleep(1)
    end
  end

end

class PageBooker < Page

  def self.get_bbc
    bbc = Page.new("http://www.bbc.com/news")
    # bbc.get_headlines_length
    bbc.get_headlines_text( ".title-link__title-text")
    bbc.print_headlines
  end

  def self.get_nyt
    nyt = Page.new("http://www.nytimes.com/pages/politics/index.html")
    nyt.get_headlines_text(".storyHeader > h2")
    nyt.get_headlines_text(".story > h3")
    nyt.print_headlines
  end

  def self.get_lat
    lat = Page.new("http://www.latimes.com/politics/")
    lat.get_headlines_text("body > div.trb_allContentWrapper > section:nth-child(5) > section.trb_outfit_sections > section.trb_outfit_primaryItem.trb_outfit_section > article > h2 > a")
    lat.get_headlines_text("body > div.trb_allContentWrapper > section:nth-child(8) > section > section.trb_outfit_list.trb_outfit_section > div > ul > li:nth-child(1) > a > h4")
    lat.get_headlines_text(".trb_outfit_list_headline_a_text")
    lat.print_headlines
  end

  def self.get_pol
    pol = Page.new("http://www.politico.com/")
    pol.get_headlines_text("#globalWrapper > main > div.super.contrast-high.overlap-bottom.homepage-section-a > div > div.content.layout-bi-unequal-fixed > section.content-groupset.pos-alpha > div > div > div.lead-group.pos-alpha > article > div > header > h1 > a")
    pol.get_headlines_text(".lead-frag format-s")
    pol.get_headlines_text(".headline-list > li")
    pol.print_headlines
  end

  def self.get_ft
    ft = Page.new("https://www.ft.com/")
    ft.get_headlines_text(".card__title-text")
    ft.print_headlines
  end

end

# Driver code

PageBooker.get_bbc
PageBooker.get_nyt
PageBooker.get_lat
PageBooker.get_pol
PageBooker.get_ft
