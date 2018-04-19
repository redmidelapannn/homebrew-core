class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.71.tar.gz"
  sha256 "fb9208d21a39f103011fe09ee8d1a37596f679df5495a8c58071c4c7b39e168c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ddbf5e3af95b3e2d2a266a38085762e232a3be11143213d6568dc29fda83c89a" => :high_sierra
    sha256 "474ddea25ffa95c78845091439837305ddcd88d627b1c123f8a25532c977bd63" => :sierra
    sha256 "43f1cd332594afa5bdc4cc3029d2e2c2b494e45d45836fddb2fb0e8f4ceb2db3" => :el_capitan
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
