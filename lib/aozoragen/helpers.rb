require 'nkf'
require 'sort_kana_jisx4061'

module Aozoragen
  module Helpers
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
  end
end
