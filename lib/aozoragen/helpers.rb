require 'nkf'
require 'sort_kana_jisx4061'

module Aozoragen
  module Helpers
    PAGE_ROW = 50

    FIRST_CHAR_MAP = {
      a: "あ", ka: "か", sa: "さ", ta: "た", na: "な",
      ha: "は", ma: "ま", ya: "や", ra: "ら", wa: "わ", zz: "他"
    }

    FIRST_CHAR_MAP_K = {
      a: "ア", ka: "カ", sa: "サ", ta: "タ", na: "ナ",
      ha: "ハ", ma: "マ", ya: "ヤ", ra: "ラ", wa: "ワ", zz: "他"
    }

    FIRST_CHAR_MAP_ALL = {
      a: {"あ"=>"ア", "い"=>"イ", "う"=>"ウ", "え"=>"エ", "お"=>"オ"},
      ka: {"か"=>"カ", "き"=>"キ", "く"=>"ク", "け"=>"ケ", "こ"=>"コ"},
      sa: {"さ"=>"サ", "し"=>"シ", "す"=>"ス", "せ"=>"セ", "そ"=>"ソ"},
      ta: {"た"=>"タ", "ち"=>"チ", "つ"=>"ツ", "て"=>"テ", "と"=>"ト"},
      na: {"な"=>"ナ", "に"=>"ニ", "ぬ"=>"ヌ", "ね"=>"ネ", "の"=>"ノ"},
      ha: {"は"=>"ハ", "ひ"=>"ヒ", "ふ"=>"フ", "へ"=>"ヘ", "ほ"=>"ホ"},
      ma: {"ま"=>"マ", "み"=>"ミ", "む"=>"ム", "め"=>"メ", "も"=>"モ"},
      ya: {"や"=>"ヤ", "ゆ"=>"ユ", "よ"=>"ヨ"},
      ra: {"ら"=>"ラ", "り"=>"リ", "る"=>"ル", "れ"=>"レ", "ろ"=>"ロ"},
      wa: {"わ"=>"ワ", "を"=>"ヲ", "ん"=>"ン"},
      zz: {"その他"=>"その他"}
    }

    FIRST_CHAR_REGEXP = {
      a: /^[ァ-オヴぁ-お]/, ka: /^[カ-ゴヵヶか-ご]/, sa: /^[サ-ゾさ-ぞ]/, ta: /^[タ-ドた-ど]/, na: /^[ナ-ノな-の]/,
      ha: /^[ハ-ポは-ぽ]/, ma: /^[マ-モま-も]/, ya: /^[ャ-ヨゃ-よ]/, ra: /^[ラ-ロら-ろ]/, wa: /^[ヮ-ンヷヸヹヺゎ-ん]/, zz: /^[^ァ-ンぁ-んヴ-ヺ]/
    }

    CHAR_LINK_MAP = {
      "あ"=>[:a, 1],  "い"=>[:a, 2],  "う"=>[:a, 3],  "え"=>[:a, 4],  "お"=>[:a, 5],
      "か"=>[:ka, 1], "き"=>[:ka, 2], "く"=>[:ka, 3], "け"=>[:ka, 4], "こ"=>[:ka, 5],
      "さ"=>[:sa, 1], "し"=>[:sa, 2], "す"=>[:sa, 3], "せ"=>[:sa, 4], "そ"=>[:sa, 5],
      "た"=>[:ta, 1], "ち"=>[:ta, 2], "つ"=>[:ta, 3], "て"=>[:ta, 4], "と"=>[:ta, 5],
      "な"=>[:na, 1], "に"=>[:na, 2], "ぬ"=>[:na, 3], "ね"=>[:na, 4], "の"=>[:na, 5],
      "は"=>[:ha, 1], "ひ"=>[:ha, 2], "ふ"=>[:ha, 3], "へ"=>[:ha, 4], "ほ"=>[:ha, 5],
      "ま"=>[:ma, 1], "み"=>[:ma, 2], "む"=>[:ma, 3], "め"=>[:ma, 4], "も"=>[:ma, 5],
      "や"=>[:ya, 1], "ゆ"=>[:ya, 2], "よ"=>[:ya, 3],
      "ら"=>[:ra, 1], "り"=>[:ra, 2], "る"=>[:ra, 3], "れ"=>[:ra, 4], "ろ"=>[:ra, 5],
      "わ"=>[:wa, 1], "を"=>[:wa, 2], "ん"=>[:wa, 3],

      "が"=>[:ka, 1], "ぎ"=>[:ka, 2], "ぐ"=>[:ka, 3], "げ"=>[:ka, 4], "ご"=>[:ka, 5],
      "ざ"=>[:sa, 1], "じ"=>[:sa, 2], "ず"=>[:sa, 3], "ぜ"=>[:sa, 4], "ぞ"=>[:sa, 5],
      "だ"=>[:ta, 1], "ぢ"=>[:ta, 2], "づ"=>[:ta, 3], "で"=>[:ta, 4], "ど"=>[:ta, 5],
      "ば"=>[:ha, 1], "び"=>[:ha, 2], "ぶ"=>[:ha, 3], "べ"=>[:ha, 4], "ぼ"=>[:ha, 5],
      "ぱ"=>[:ha, 1], "ぴ"=>[:ha, 2], "ぷ"=>[:ha, 3], "ぺ"=>[:ha, 4], "ぽ"=>[:ha, 5],
      "ゔ"=>[:a, 3],

      "ア"=>[:a, 1],  "イ"=>[:a, 2],  "ウ"=>[:a, 3],  "エ"=>[:a, 4],  "オ"=>[:a, 5],
      "カ"=>[:ka, 1], "キ"=>[:ka, 2], "ク"=>[:ka, 3], "ケ"=>[:ka, 4], "コ"=>[:ka, 5],
      "サ"=>[:sa, 1], "シ"=>[:sa, 2], "ス"=>[:sa, 3], "セ"=>[:sa, 4], "ソ"=>[:sa, 5],
      "タ"=>[:ta, 1], "チ"=>[:ta, 2], "ツ"=>[:ta, 3], "テ"=>[:ta, 4], "ト"=>[:ta, 5],
      "ナ"=>[:na, 1], "ニ"=>[:na, 2], "ヌ"=>[:na, 3], "ネ"=>[:na, 4], "ノ"=>[:na, 5],
      "ハ"=>[:ha, 1], "ヒ"=>[:ha, 2], "フ"=>[:ha, 3], "ヘ"=>[:ha, 4], "ホ"=>[:ha, 5],
      "マ"=>[:ma, 1], "ミ"=>[:ma, 2], "ム"=>[:ma, 3], "メ"=>[:ma, 4], "モ"=>[:ma, 5],
      "ヤ"=>[:ya, 1], "ユ"=>[:ya, 2], "ヨ"=>[:ya, 3],
      "ラ"=>[:ra, 1], "リ"=>[:ra, 2], "ル"=>[:ra, 3], "レ"=>[:ra, 4], "ロ"=>[:ra, 5],
      "ワ"=>[:wa, 1], "ヲ"=>[:wa, 2], "ン"=>[:wa, 3],

      "ガ"=>[:ka, 1], "ギ"=>[:ka, 2], "グ"=>[:ka, 3], "ゲ"=>[:ka, 4], "ゴ"=>[:ka, 5],
      "ザ"=>[:sa, 1], "ジ"=>[:sa, 2], "ズ"=>[:sa, 3], "ゼ"=>[:sa, 4], "ゾ"=>[:sa, 5],
      "ダ"=>[:ta, 1], "ヂ"=>[:ta, 2], "ヅ"=>[:ta, 3], "デ"=>[:ta, 4], "ド"=>[:ta, 5],
      "バ"=>[:ha, 1], "ビ"=>[:ha, 2], "ブ"=>[:ha, 3], "ベ"=>[:ha, 4], "ボ"=>[:ha, 5],
      "パ"=>[:ha, 1], "ピ"=>[:ha, 2], "プ"=>[:ha, 3], "ペ"=>[:ha, 4], "ポ"=>[:ha, 5],
      "ヴ"=>[:a, 3],
    }

    def author_list_index_inpage(first_sym)
      str = ""
      FIRST_CHAR_MAP_ALL[first_sym].each_with_index do |(key, val), idx|
        str << %w(<a href="#sec#{idx+1}">[#{val}]</a>　)
      end

      str
    end

    ## middle_str: "" or "_all" or "_inp"
    def author_list_index(first_char, middle_str)
      links = FIRST_CHAR_MAP.map do |key, val|
        if first_char == val
          "<span class=\"current\">[#{val}]</span>"
        else
          "<a href=\"person#{middle_str}_#{key}.html\">[#{val}]</a>"
        end
      end

      links.join('')
    end

    def name_first_kana(str)
      NKF.nkf('-w --katakana', str[0])
    end

    def name_sort(str)
      str
    end

def make_first_char(kana)
  kata = NKF.nkf('-w --katakana', kana.gsub(/[“「『]/, ''))
  kata[0]
end

def select_person(person)
  first_char = make_first_char(person['name_kana'])
  data = CHAR_LINK_MAP[first_char]
  if data && data[0]
    data[0]
  else
    nil
  end
end

def select_list(list)
  buf = {a:[],ka:[],sa:[],ta:[],na:[],ha:[],ma:[],ya:[],ra:[],wa:[]}
  list.each do |person|
    key = select_person(person)
    buf[key] << person
  end

  buf.each do |k, v|
    buf[k] = sort_kana_jisx4061_by(v){|item| item["name_kana"].gsub(/[“「『・]/, '')}
  end
  buf
end

    def link_to_person_list_by_kana(name_kana, status = :open)
      first_char = name_kana[0]
      kana_postfix, num = CHAR_LINK_MAP[first_char]

      case status
      when :input
        link_to "作業", "person_inp_#{kana_postfix}.html\#sec#{num}", relative: true
      when :all
        link_to "全", "person_all_#{kana_postfix}.html\#sec#{num}", relative: true
      else # :open
        link_to "公開", "person_#{kana_postfix}.html\#sec#{num}", relative: true
      end
    end

    def link_to_card(person, work)
      person_id = work['person_id'] || person['id']
      link_to work['title'], sprintf("../cards/%06d/card%d.html", person_id, work["work_id"])
    end

    def download_link(filename)
      if filename =~ /^http/
        %Q|<a href="#{filename}">#{filename}</a>|
      else
        %Q|<a href="./files/#{filename}">#{filename}</a>|
      end
    end

    def download_icon(filetype)
      ft = {"入力完了ファイル" => 0,
            "テキストファイル(ルビあり)" => 1,
            "テキストファイル(ルビなし)" => 2,
            "HTMLファイル" => 3,
            "エキスパンドブックファイル" => 4,
            ".bookファイル" => 5,
            "TTZファイル" => 6,
            "PDFファイル" => 7,
            "PalmDocファイル" => 8,
            "XHTMLファイル" => 9,
            "その他" => 99}

      if !ft[filetype] || filetype == 'その他'
        ''
      else
        %Q|<img src="../images/f#{ft[filetype]}.png" width="16" height="16" border="0" alt="#{filetype}アイコン">|
      end
    end

    def base_person_tag(alt_id, alt_name)
      if alt_id && alt_name
        "(→<a href=\"person#{alt_id}.html\">#{alt_name}</a>)"
      else
        ''
      end
    end

    def copyright_tag(val)
      if val
        '　<strong>＊著作権存続＊</strong>'
      else
        ''
      end
    end

    # pagenateを文字列として生成する
    #
    # cur_num, nax_numは1から始まる(1オリジン)
    def page_str_index(url, max_num, cur_num, page_size = PAGE_ROW)
      ## 1ページしかない場合は空文字を返す
      return "" if max_num < 2

      buf = ""
      buf << "<table align=center width=700 border=0><tr><td width=90 align=left valign=bottom>"
      if cur_num > 1
        buf << %Q|<a href="#{url}#{cur_num - 1}.html">前の#{page_size}件</a>|
      end
      buf << %Q|</td><td  align=right valign=bottom>ページ：|
      1.upto(max_num) do |i|
        if i == cur_num
          buf << %Q|<font size="5">#{i}</font> |
        else
          buf << %Q|<a href="#{url}#{i}.html">#{i}</a> |
        end
      end
      buf << "</td><td width=90 align=right valign=bottom>"
      if cur_num < max_num
        buf << %Q|<a href="#{url}#{cur_num + 1}.html">次の#{page_size}件</a>|
      end
      buf << "</td></tr></table>"

      buf
    end

  end
end
