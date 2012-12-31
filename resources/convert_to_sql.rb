#!/usr/bin/env ruby -KU
require 'nokogiri'
require 'sqlite3'
require 'pry'

# Sample Entry
# <character>
#     <literal>唖</literal>
#     <codepoint>
#         <cp_value cp_type="ucs">5516</cp_value>
#         <cp_value cp_type="jis208">16-2</cp_value>
#     </codepoint>
#     <radical>
#         <rad_value rad_type="classical">30</rad_value>
#     </radical>
#     <misc>
#         <stroke_count>10</stroke_count>
#         <variant var_type="jis212">21-64</variant>
#         <variant var_type="jis212">45-68</variant>
#     </misc>
#     <dic_number>
#         <dic_ref dr_type="nelson_c">939</dic_ref>
#         <dic_ref dr_type="nelson_n">795</dic_ref>
#         <dic_ref dr_type="heisig">2958</dic_ref>
#         <dic_ref dr_type="moro" m_vol="2" m_page="1066">3743</dic_ref>
#     </dic_number>
#     <query_code>
#         <q_code qc_type="skip">1-3-7</q_code>
#         <q_code qc_type="sh_desc">3d8.3</q_code>
#         <q_code qc_type="four_corner">6101.7</q_code>
#     </query_code>
#     <reading_meaning>
#         <rmgroup>
#             <reading r_type="pinyin">ya1</reading>
#             <reading r_type="korean_r">a</reading>
#             <reading r_type="korean_h">아</reading>
#             <reading r_type="ja_on">ア</reading>
#             <reading r_type="ja_on">アク</reading>
#             <reading r_type="ja_kun">おし</reading>
#             <meaning>mute</meaning>
#             <meaning>dumb</meaning>
#         </rmgroup>
#     </reading_meaning>
# </character>

db = SQLite3::Database.new "KanjiDic2.db"

rows = db.execute <<-SQL
  create table numbers (
    name varchar(30),
    val int
  );
SQL


KanjiDictFile = File.open( 'formatted_simplified_kanjidic2.xml' )
dictionary = Nokogiri::XML( KanjiDictFile )

dictionary.search("//character").each do |entry|
	## TODO: Convert into sql database

	cur_kanji = {}

	cur_kanji[:literal] = entry.search("//literal/child::text()")[0].text

	cur_kanji[:on_readings] = []
	entry.search("//reading_meaning//reading[@r_type='ja_on']/child::text()")
	.each { |on| cur_kanji[:on_readings].push on.text }

	cur_kanji[:kun_readings] =[]
	entry.search("//reading_meaning//reading[@r_type='ja_kun']/child::text()")
	.each { |kun| cur_kanji[:kun_readings].push kun.text }

	cur_kanji[:meanings] =[]
	entry.search("//reading_meaning//meaning/child::text()")
	.each { |meaning| cur_kanji[:meanings].push meaning.text }

end

binding.pry

KanjiDictFile.close

