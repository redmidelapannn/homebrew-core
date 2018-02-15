class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "https://www.tracebox.org/"
  url "https://github.com/tracebox/tracebox.git",
      :tag => "v0.4.4",
      :revision => "4fc12b2e330e52d340ecd64b3a33dbc34c160390"
  head "https://github.com/tracebox/tracebox.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "af6de794d6e5fccdee9d06419174af6626af2748743294e63541da2d32dba45d" => :high_sierra
    sha256 "ed47a7c4e72fc41533cebcf1e9d0886af044c3746a440de72d07c2475983e69a" => :sierra
    sha256 "60faa4942cc09912fc10ee184f57e386e0f663146fef4f6fc50e3223cdc9cd6a" => :el_capitan
  end

  needs :cxx11

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "lua"
  depends_on "json-c"

  def install
    ENV.libcxx
    system "autoreconf", "--install"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  def caveats; <<~EOS
    Tracebox requires superuser privileges e.g. run with sudo.

    You should be certain that you trust any software you are executing with
    elevated privileges.
    EOS
  end

  test do
    system bin/"tracebox", "-v"
  end
end
