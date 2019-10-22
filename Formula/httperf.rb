class Httperf < Formula
  desc "Tool for measuring webserver performance"
  homepage "https://github.com/httperf/httperf"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/httperf/httperf-0.9.0.tar.gz"
  sha256 "e1a0bf56bcb746c04674c47b6cfa531fad24e45e9c6de02aea0d1c5f85a2bf1c"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "41c97b5caa0278b7394cfa062f34bf0770f5b072b8dc3034cdcdb42a22fab9d3" => :catalina
    sha256 "3f0db17cbc5bd692f689511760895cc90bcf995d688b3443a84149473d9010a2" => :mojave
    sha256 "7d604806e09c0f094b266bcb6b168676c99ebb53df4b9e4007259eaba1277a4c" => :high_sierra
  end

  head do
    url "https://github.com/httperf/httperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  # Upstream patch for OpenSSL 1.1 compatibility
  # https://github.com/httperf/httperf/pull/48
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/httperf/openssl-1.1.diff"
    sha256 "69d5003f60f5e46d25813775bbf861366fb751da4e0e4d2fe7530d7bb3f3660a"
  end

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/httperf", "--version"
  end
end
