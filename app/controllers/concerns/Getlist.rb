module Getlist
  extend ActiveSupport::Concern
  def languageHash
    return {#숫자 => 언어, db 컬럼이름, 언어풀네임(영어로)
        4 => ["한국어", "kname", "korean"],
        2 => ["汉语", "cname", "chinese"],
        7 => ["Deutsch", "germany", "germany"],
        0 => ["English", "ename", " english"],
        6 => ["Español", "spanish", "spanish"],
        11 => ["Esperanto", "esperanto", "esperanto"],
        10 => ["Français", "french", "france"],
        8 => ["Italiano", "italia", "italia"],
        9 => ["Português", "portugal", "portugal"],
      }
  end
  
  def restCategoryHash
    return{#쿼리 => [영어,독음,중국어,일어,한국어]
      "한식" => ["Korean", "Korean","韩式","Korean","한식"],
      "세계" => ["World", "World","世界","World","세계"]
    }
  end
  
  def oLanguageHash
    return {
        0 => ["English", "english"],
        4 => ["한국어", "korean"],
        2 => ["汉语", "chinese"]
      }
  end
end