class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/1.0.3.tar.gz"
  sha256 "ce45de7412ee0ae6f22d72e17b81425666e6130da8cb434d5ca8ea42185e514e"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "35cadf25a7beeafc8789c7f1b39dd1422ebd2caa32452f8a27dd8c24fc293a70" => :sierra
    sha256 "4b13003479835155e6232d465572e97f535c299f65a5ba5062a231a28423ab24" => :el_capitan
    sha256 "80862f1eaa70c7e4e48da1724b308b1d141c28e24b09f14ca5694489bd0d4bad" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz" => :recommended

  def install
    # Stable tarball does not include pre-generated configure script
    system "autoreconf", "-fiv"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-lzma" if build.without?("xz")

    system "./configure", *args
    system "make"
    system "make", "install"

    bash_completion.install "ag.bashcomp.sh"
  end

  test do
    (testpath/"Hello.txt").write("Hello World!")
    system "#{bin}/ag", "Hello World!", testpath
  end
end
