class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "https://www.eca.cx/ecasound/"
  url "https://ecasound.seul.org/download/ecasound-2.9.1.tar.gz"
  sha256 "39fce8becd84d80620fa3de31fb5223b2b7d4648d36c9c337d3739c2fad0dcf3"

  bottle do
    rebuild 1
    sha256 "b06baedb17f685811e7a5ed036732cdbbe9a17be69dea4e591e1d58794022b35" => :sierra
    sha256 "2a41253892637a594b4803e00ad5766f65e57232bbb440c7c57993a300c220d2" => :el_capitan
    sha256 "cfa2cfccafd7dbe07f4c5b124e256cfce8d83021426b9202b629fdf3f601aadb" => :yosemite
  end

  option "with-ruby", "Compile with ruby support"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--enable-rubyecasound=" + (build.with?("ruby") ? "yes" : "no")
    system "./configure", *args
    system "make", "install"
  end
end
