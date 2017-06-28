module Getlist
  extend ActiveSupport::Concern
  def languageHash
    return {
        4 => {
          showName: "한국어",
          dbName: "kname",
          dataTransName: "korean"
        },
        2 => {
          showName: "汉语",
          dbName: "cname",
          dataTransName: "chinese"
        },
        7 => {
          showName: "Deutsch",
          dbName: "germany",
          dataTransName: "germany"
        },
        0 => {
          showName: "English",
          dbName: "ename",
          dataTransName: "english"
        },
        6 => {
          showName: "Español",
          dbName: "spanish",
          dataTransName: "spanish"
        },
        11 => {
          showName: "Esperanto",
          dbName: "esperanto",
          dataTransName: "esperanto"
        },
        10 => {
          showName: "Français",
          dbName: "french",
          dataTransName: "france"
        },
        8 => {
          showName: "Italiano",
          dbName: "italia",
          dataTransName: "italia"
        },
        9 => {
          showName: "Português",
          dbName: "portugal",
          dataTransName: "portugal"
        },
      }
  end
  
  def restCategoryHash
    return{#쿼리 => [영어,독음,중국어,일어,한국어]
      "한식" => ["Korean", "Korean", "韩式","Korean", "한식"],
      "세계" => ["World", "World", "世界", "World", "세계"]
    }
  end
  
  def oLanguageHash
    return {
        0 => {
          showName: "English",
          dataTransName: "english"
        },
        4 => {
          showName: "한국어",
          dataTransName: "korean"
        },
        2 => {
          showName: "汉语",
          dataTransName: "chinese"
        }
      }
  end
end