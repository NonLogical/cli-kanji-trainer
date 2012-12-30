require 'nokogiri'
require 'pry'

KanjiDictFile = File.open( './resources/kanjidic2.xml' )
dictionary = Nokogiri::XML( KanjiDictFile )


binding.pry

KanjiDictFile.close