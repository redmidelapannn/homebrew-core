class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  url "https://deb.debian.org/debian/pool/main/libe/libewf/libewf_20171104.orig.tar.gz"
  version "20171104"
  sha256 "cf36d3baf3a96dbe566fde55ae7d79fc2e7b998806ab13e0f69915799f19e040"

  bottle do
    cellar :any
    sha256 "2f29ae2323632c6ce3d6d2ea7fbafb1e65e85803ae62ba18da5e332fd9ff5932" => :mojave
    sha256 "56fede8e39bbd30058efe184a070443151373352e943795547ab4f947df170d8" => :high_sierra
    sha256 "3daeeb29fa134f748198570af18f738c508627f74c7b9af11ca9b51495cbe7b0" => :sierra
  end

  head do
    url "https://github.com/libyal/libewf.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libfuse=no
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
