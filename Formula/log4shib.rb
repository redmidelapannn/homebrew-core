class Log4shib < Formula
  desc "Forked version of log4cpp for the Shibboleth project"
  homepage "https://wiki.shibboleth.net/confluence/display/OpenSAML/log4shib"
  url "https://shibboleth.net/downloads/log4shib/2.0.0/log4shib-2.0.0.tar.gz"
  sha256 "d066e2f208bdf3ce28e279307ce7e23ed9c5226f6afde288cd429a0a46792222"

  bottle do
    cellar :any
    sha256 "82612506d0bcc9ee288c346747575c587b151c0e363f40d98727178842af46e5" => :high_sierra
    sha256 "cf993b1399e183be8bcfe5711ef446c89670c0b2193f41e06a17639fb18247e2" => :sierra
    sha256 "4d27c929fe5ebf3650d093a35d488463af8c16a1ffd11020c377808453369022" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_equal "-L#{HOMEBREW_PREFIX}/Cellar/log4shib/1.0.9/lib -llog4shib",
                 shell_output("#{bin}/log4shib-config --libs").chomp
  end
end
