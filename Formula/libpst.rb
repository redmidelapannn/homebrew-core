class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.71.tar.gz"
  sha256 "fb9208d21a39f103011fe09ee8d1a37596f679df5495a8c58071c4c7b39e168c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bd6691ae0de172fd4a61b97cb495815c7396e9d84c28c68434b31c0057f13559" => :high_sierra
    sha256 "3c796ca2442bd6a5e10c2065f52fb2832a7ffba17b4b3246ec67b491faa67ee3" => :sierra
    sha256 "e1cfd583a68272db966d3a642d0c8a9eb40067574ec6147c47f574d4630e493b" => :el_capitan
  end

  option "with-pst2dii", "Build pst2dii using gd"

  deprecated_option "pst2dii" => "with-pst2dii"
  deprecated_option "with-python" => "with-python@2"

  depends_on "python@2" => :optional
  depends_on "pkg-config" => :build
  depends_on "gd" if build.with? "pst2dii"
  depends_on "boost"
  depends_on "gettext"
  depends_on "libgsf"
  depends_on "boost-python" if build.with? "python@2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-dii" if build.with? "pst2dii"

    if build.with? "python@2"
      args << "--enable-python" << "--with-boost-python=mt"
    else
      args << "--disable-python"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
