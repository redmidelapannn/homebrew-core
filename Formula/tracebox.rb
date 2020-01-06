class Tracebox < Formula
  desc "Middlebox detection tool"
  homepage "https://www.tracebox.org/"
  url "https://github.com/tracebox/tracebox.git",
      :tag      => "v0.4.4",
      :revision => "4fc12b2e330e52d340ecd64b3a33dbc34c160390"
  revision 1
  head "https://github.com/tracebox/tracebox.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "00ba97e411eede6b0a34377100c6bd3d783d17c64ed2addb4cd1d174720be74a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "json-c"
  depends_on "lua"

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
