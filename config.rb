# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

require 'lib/aozoragen/helpers'
helpers Aozoragen::Helpers

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

Aozoragen::Helpers::FIRST_CHAR_MAP.keys.each do |char|
  proxy "index_pages/person_#{char}.html", "index_pages/person_tmpl.html", locals: {first_char: char}, ignore: true
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
