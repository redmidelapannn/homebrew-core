class Wordgrinder < Formula
  desc "Unicode-aware word processor that runs in a terminal"
  homepage "https://cowlark.com/wordgrinder"
  url "https://github.com/davidgiven/wordgrinder/archive/0.7.2.tar.gz"
  sha256 "4e1bc659403f98479fe8619655f901c8c03eb87743374548b4d20a41d31d1dff"
  head "https://github.com/davidgiven/wordgrinder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d571cba3a529a9cdb57096f127353cc8f82e5b32235787b728454e4919404eb5" => :mojave
    sha256 "15c8150ec96276ac16629a8fe1ffc6bec03528304d54863317591c2ff809ce32" => :high_sierra
    sha256 "c71bd73f183cd6ec8b54390bb9270750ef7901e95e447a130816b250891ebfeb" => :sierra
  end

  depends_on "lua"
  depends_on "ninja"

  def install
    system "make", "OBJDIR=#{buildpath}/wg-build"
    bin.install "bin/wordgrinder-builtin-curses-release" => "wordgrinder"
    man1.install "bin/wordgrinder.1" => "wordgrinder.1"
    doc.install "README.wg"
  end

  test do
    system "#{bin}/wordgrinder", "--convert", "#{doc}/README.wg", "#{testpath}/converted.txt"
    assert_predicate testpath/"converted.txt", :exist?
  end
end
