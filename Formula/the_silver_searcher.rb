class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/2.2.0.tar.gz"
  sha256 "6a0a19ca5e73b2bef9481c29a508d2413ca1a0a9a5a6b1bd9bbd695a7626cbf9"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "88ec44c35731d5af69aef1a5fdd4923700f14aea66c046f0bc6dc8823e3c55c9" => :mojave
    sha256 "3f5f811b83f2f1590bc42bac7b4dcd026e49ffe631a8ab55ed3bd28501245743" => :high_sierra
    sha256 "7d32724818c920e5f215230de86842df53fa2800d32edfe01f6381a33ad201e7" => :sierra
    sha256 "5ba1b853318ec422fb5cae097b109113c8963b89345bf3ec0e3f968bed1f333d" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz"

  def install
    # Stable tarball does not include pre-generated configure script
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/ag", "Hello World!", testpath
  end
end
