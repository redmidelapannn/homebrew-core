class Direvent < Formula
  desc "Monitors events in the file system directories"
  homepage "http://www.gnu.org.ua/software/direvent/direvent.html"
  url "https://ftpmirror.gnu.org/direvent/direvent-5.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/direvent/direvent-5.1.tar.gz"
  sha256 "c461600d24183563a4ea47c2fd806037a43354ea68014646b424ac797a959bdb"

  bottle do
    sha256 "82cef0ad61c862d94ab7809b3167f0e1c9df8b4eba82ea52ea8119692f8935b4" => :el_capitan
    sha256 "b1023c15577e2c224a1c1b2ff153c3e923d0597073eb768f38bd51ff782338c7" => :yosemite
    sha256 "42ebddb577b67b33b9cc8b0c52b462c38ce37f28380668096975e0941e045f3e" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "-C", "tests", "check-local"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/direvent --version")
  end
end
