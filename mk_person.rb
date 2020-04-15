#!/usr/bin/env ruby

require 'json'
require_relative 'lib/aozoragen/helpers'

include Aozoragen::Helpers

def split_person_detail
  content = File.read("data/person_detail.json")
  json = JSON.parse(content)

  FIRST_CHAR_REGEXP.each do |key, val|
    buf = []
    json.each do |person|
      person["name_first_kana"] = name_first_kana(person["name_kana"])
      person["name_sort"] = name_sort(person["name_kana"])
      if person["name_kana"] =~ val
        buf << person
      end
    end

    buf = sort_kana_jisx4061_by(buf){|a| a["name_sort"]}

    File.write("data/person_#{key}.json", JSON.generate(buf))
  end
end

## main
split_person_detail()
