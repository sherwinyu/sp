module Util
  class Git
    def self.git
      git = Hashie::Mash.new
      git_lines = `git log -n1 `.split("\n").map &:strip

      # commit 3454bb9545a7b9658a99fcde79ef1e864015c496
      git.sha1 = git_lines[0].split.last

      # "Author: Sherwin Yu <sherwin.x.yu@gmail.com>"
      git.author = git_lines[1].split[1..4].join(" ")

      # "Date:   Tue Dec 17 23:27:43 2013 -0500"
      git.date = ::DateTime.parse git_lines[2].partition(/Date:\s+/)[2]

      git.message = git_lines[3..-1].map(&:strip).join ' '
      git
    end
  end
end
=begin
irb(main):015:0> s = `git log -n1 `
=> "commit 3454bb9545a7b9658a99fcde79ef1e864015c496\nAuthor: Sherwin Yu <sherwin.x.yu@gmail.com>\nDate:   Tue Dec 17 23:27:43 2013 -0500\n\n    Add toggle debug\n"
=end
