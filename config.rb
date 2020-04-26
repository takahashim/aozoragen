# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

require 'lib/aozoragen/helpers'
helpers Aozoragen::Helpers
require 'date'

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

Aozoragen::Helpers::FIRST_CHAR_MAP.keys.each do |char|
  proxy "index_pages/person_#{char}.html", "index_pages/person_tmpl.html", locals: {first_char: char}, ignore: true
  proxy "index_pages/person_all_#{char}.html", "index_pages/person_all_tmpl.html", locals: {first_char: char}, ignore: true
end

data.person_detail.each do |person|
  proxy "index_pages/person#{person["id"]}.html",
        "index_pages/person_card_tmpl.html",
        locals: {person: person, listURL: ""},
        ignore: true
end

data.card.each do |card|
  proxy "cards/#{"%06d" % card['title']['person_id']}/card#{card['title']['work_id']}.html",
        "cards/card_tmpl.html",
        locals: {card: card, listURL: ""},
        ignore: true
end

## TODO: 1/1を考慮する
whatsnew_size = data.whatsnew.size
cur_year = Time.now.year
cur_date = Time.now.strftime("%Y-%m-%d").split("-").map(&:to_i).join(".")
page_count = (whatsnew_size / Aozoragen::Helpers::PAGE_ROW) + 1
page_count.times do |i|
  proxy "index_pages/whatsnew#{i+1}.html",
        "index_pages/whatsnew_tmpl.html",
        locals: {page_idx: i, cur_year: cur_year, title: "新規公開作品　#{cur_year}年公開分", page_max: page_count,
                 cur_date: cur_date},
        ignore: true
end

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end

activate :livereload
