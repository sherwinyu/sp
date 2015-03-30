task :annotate_resolution_keys => :environment do
  map = {
    coded: "Commit on non-work stuff once per day.",
    coded_in_am: "Commit before 10AM.",
    mindfulness: "Health: Daily 5m Mindfulness meditation ",
    in_bed_by_1130: "Health: In bed reading by 11:30pm",
    chns_sentence: "Chinese: add Chinese Sentence cards",
    chns_hsk: "Chinese: 1500 Anki HS6 notes",
  }
#   unless Resolution.find_by(key: :coded)
#     resolution = Resolution.find_by text: texts[:coded]
#     resolution.key = :coded
#   end
#   "I. Commitment: once a week (sat or sun) ",
#   [ 1] "Treat as higher priority over other things",
#   [ 6] "30 minutes spent on structured expression of appreciation during Sherwin Sunday",
#   [ 7] "Get a girlfriend",
#   [ 9] "Commitment: cardioboxing",
#   [10] "Ankify stuff",
#   [11] "Longer sitting reflection",
#   [12] "Longer SP work session",
#   [13] "Commitment: Yoga",
#   [14] "Health: In bed reading by 11:30pm",
#   [15] "Untitled resolution",
#   [16] "Untitled resolution",
#   [17] "Untitled resolution",
#   [18] "Untitled resolution",
#   [19] "Plan out and commit to it by 5pm on Friday beforehand"
end
