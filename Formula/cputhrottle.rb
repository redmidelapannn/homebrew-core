class Cputhrottle < Formula
  desc "Limit the CPU usage of a process"
  homepage "http://www.willnolan.com/cputhrottle/cputhrottle.html"
  # http://www.willnolan.com/cputhrottle/cputhrottle.tar.gz has a different
  # checksum; contacted the author 18 Sep 2017 requesting versioned tarballs.
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/cputhrottle/20100515/cputhrottle.tar.gz"
  mirror "https://dl.bintray.com/homebrew/mirror/cputhrottle-20100515.tar.gz"
  version "20100515"
  sha256 "fdf284e1c278e4a98417bbd3eeeacf40db684f4e79a9d4ae030632957491163b"
  revision 1

  bottle do
    rebuild 1
    sha256 "a5de5e6f5995a6fb8a5c76d4c7e7ae33c4dab5d8603c4dbb426ea80368bd3e24" => :sierra
    sha256 "b2e45c22f8bdc5b16c200930c725d41c6409466192cd7e38c6a8af44a0455c4b" => :el_capitan
  end

  depends_on "boost" => :build

  def install
    boost = Formula["boost"]
    system "make", "BOOST_PREFIX=#{boost.opt_prefix}",
                   "BOOST_INCLUDES=#{boost.opt_include}",
                   "all"
    bin.install "cputhrottle"
  end

  test do
    # Needs root for proper functionality test.
    output = pipe_output("#{bin}/cputhrottle 2>&1")
    assert_match "Please supply PID to throttle", output
  end
end
