class MonoLibgdiplus < Formula
  desc "GDI+-compatible API on non-Windows operating systems"
  homepage "https://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/archive/5.6.tar.gz"
  sha256 "6a75e4a476695cd6a1475fd6b989423ecf73978fd757673669771d8a6e13f756"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d551ba53e7bbc8e04c52e9440b62b56f3c964226047aa8a631c5123b13507d16" => :high_sierra
    sha256 "1aa8eb15f2290e3c4fce8c9d39f91f83ab496eba6930981831d9b6cadde47af0" => :sierra
    sha256 "5116aa1e99d58919620ad2a8eb207802f63a0dd774b3f2ca5c403d8b665179e5" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "giflib"
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pixman"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-x11",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make"
    cd "tests" do
      system "make", "testbits"
      system "./testbits"
    end
    system "make", "install"
  end

  test do
    # Since no headers are installed, we just test that we can link with
    # libgdiplus
    (testpath/"test.c").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lgdiplus", "-o", "test"
  end
end
