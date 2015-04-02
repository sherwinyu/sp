task :annotate_resolution_keys => :environment do
  resolution_key_text_map = {
    coded: "Commit on non-work stuff once per day.",
    coded_in_am: "Commit before 10AM.",
    mindfulness: "Health: Daily 5m Mindfulness meditation ",
    in_bed_by_1130: "Health: In bed reading by 11:30pm",
    chns_sentence: "Chinese: add Chinese Sentence cards",
    chns_hsk: "Chinese: 1500 Anki HS6 notes",
  }
  resolution_key_text_map.each do |k, text|
    resolution = Resolution.find_by text: text
    resolution.key = k
    ap resolution
    resolution.save
  end
end
