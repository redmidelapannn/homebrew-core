class TheSilverSearcher < Formula
  desc "Code-search similar to ack"
  homepage "https://github.com/ggreer/the_silver_searcher"
  url "https://github.com/ggreer/the_silver_searcher/archive/0.32.0.tar.gz"
  sha256 "c5b208572e5cfc8a3cf366e8eb337b0c673c2ffa90c1ad90dfdcbe78251ba4cc"
  head "https://github.com/ggreer/the_silver_searcher.git"

  bottle do
    cellar :any
    revision 1
    sha256 "c629c9395b8eee387bfa7641d6a18a2cfc3191efa25d81d8fa5ff53ff0148a2b" => :el_capitan
    sha256 "8c1602ea6774d348d3aa17cf2680e077f61f4b4cae8c023d95dcadbfb2955cc8" => :yosemite
    sha256 "21fba50763c19007de642be333fe124f94ab05b8ac9ae9788e1f5aca772dcea2" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "pkg-config" => :build
  depends_on "pcre"
  depends_on "xz" => :recommended

  def install
    # Stable tarball does not include pre-generated configure script
    system "aclocal", "-I #{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "autoheader"
    system "automake", "--add-missing"

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
