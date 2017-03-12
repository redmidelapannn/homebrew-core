class Ecasound < Formula
  desc "Multitrack-capable audio recorder and effect processor"
  homepage "https://www.eca.cx/ecasound/"
  url "https://ecasound.seul.org/download/ecasound-2.9.1.tar.gz"
  sha256 "39fce8becd84d80620fa3de31fb5223b2b7d4648d36c9c337d3739c2fad0dcf3"

  bottle do
    rebuild 1
    sha256 "079f4a5db103cb5163b281363b7e98dd0eff6ed91f8f7e6054cc0fcce0a83478" => :sierra
    sha256 "42ca9570a2865024f1983b20dddf1674fb4cfe3bd421f0b142618a6467711be6" => :el_capitan
    sha256 "e79f07e5a679f53e62b118a6f06ac29edd775f179bb2468543a70307b8cc532e" => :yosemite
  end

  option "with-ruby", "Compile with ruby support"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << ("--enable-rubyecasound=" + ((build.with? "ruby") ? "yes" : "no"))
    system "./configure", *args
    system "make", "install"
  end
end
