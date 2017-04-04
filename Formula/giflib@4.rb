class GiflibAT4 < Formula
  desc "GIF library using patented LZW algorithm"
  homepage "https://giflib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/giflib/giflib-4.x/giflib-4.2.3.tar.bz2"
  sha256 "0ac8d56726f77c8bc9648c93bbb4d6185d32b15ba7bdb702415990f96f3cb766"

  bottle do
    cellar :any
    sha256 "ca5d749a8fe941b292110121c88b590146e0503a023e1c4a517b29f5c1369d04" => :sierra
    sha256 "5c641d5c0bbc3f14cebd2e8948fd4987394c11d0383c6cea0600155ac5ffcede" => :el_capitan
    sha256 "f700ea8d79da7c1e232753979c6b2497e4b6e36a97ecb5f1d2a58e13658cb70f" => :yosemite
  end

  keg_only :versioned_formula

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-x11",
                          "--without-x"
    system "make", "install"
  end

  test do
    assert_match /Size: 1x1/, shell_output("#{bin}/gifinfo #{test_fixtures("test.gif")}")
  end
end
