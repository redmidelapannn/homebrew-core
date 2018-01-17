class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"
  revision 1

  bottle do
    rebuild 2
    sha256 "bb8fd4ce06b3ea269926c3896a7435f050736af2998f178cede4d4d787183b57" => :high_sierra
    sha256 "c4f787c7cc60d7b0d461e1dd8b3838de57bbe537f90b349730b79c4ef90e333b" => :sierra
    sha256 "daeae85a7a816bd37a6ed0967b5ba7e6357b860d438825cd90c313263e013c8c" => :el_capitan
  end

  option "with-gcc", "Build Fortran bindings"
  option "with-libzzip", "Build with zzip compression support"
  option "with-perl", "Build against Homebrew's Perl rather than system default"
  option "with-xz", "Build with LZMA compression support"

  deprecated_option "lzma" => "with-xz"
  deprecated_option "zzip" => "with-libzzip"
  deprecated_option "with-fortran" => "with-gcc"

  depends_on "libtool" => :run
  depends_on "gcc" => :optional
  depends_on "libzzip" => :optional
  depends_on "perl" => :optional
  depends_on "xz" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-php
      --disable-python
      --with-perl-dir=#{lib}/perl5/site_perl
    ]

    args << "--without-liblzma" if build.without? "xz"
    args << "--without-libzzip" if build.without? "libzzip"
    args << "--disable-fortran" << "--disable-fortran95" if build.without? "gcc"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
