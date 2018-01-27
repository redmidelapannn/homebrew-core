class ImessageRuby < Formula
  desc "Command-line tool to send iMessage"
  homepage "https://github.com/linjunpop/imessage"
  url "https://github.com/linjunpop/imessage/archive/v0.3.1.tar.gz"
  sha256 "74ccd560dec09dcf0de28cd04fc4d512812c3348fc5618cbb73b6b36c43e14ef"
  head "https://github.com/linjunpop/imessage.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "302495acccd21891e9c25aaca5d419e956a05d27a3000ecca8652bc43f22bc98" => :high_sierra
    sha256 "302495acccd21891e9c25aaca5d419e956a05d27a3000ecca8652bc43f22bc98" => :sierra
    sha256 "302495acccd21891e9c25aaca5d419e956a05d27a3000ecca8652bc43f22bc98" => :el_capitan
  end

  depends_on :macos => :mavericks

  def install
    system "rake", "standalone:install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/imessage", "--version"
  end
end
