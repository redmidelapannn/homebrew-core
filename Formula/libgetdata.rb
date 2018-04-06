class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.10.0/getdata-0.10.0.tar.xz"
  sha256 "d547a022f435b9262dcf06dc37ebd41232e2229ded81ef4d4f5b3dbfc558aba3"
  revision 1

  bottle do
    rebuild 3
    sha256 "92d1bf28a6ef205ff6a893670fd39d724ae50acfbdc01be7fb78a0652436eec5" => :high_sierra
    sha256 "c51e10a7aabf1d3a909bbc582e16b1756366072c742107ca4234716f70cfc6c4" => :sierra
    sha256 "0aca64571c0d861114c9edf4746bb2f368975e2c6300a09d81744857ea384b4a" => :el_capitan
  end

  option "with-gcc", "Build Fortran bindings"
  option "with-libzzip", "Build with zzip compression support"
  option "with-perl", "Build against Homebrew's Perl rather than system default"
  option "with-php", "Build PHP bindings"
  option "with-python", "Build Python3 bindings"
  option "with-python@2", "Build Python2 bindings"
  option "with-xz", "Build with LZMA compression support"

  deprecated_option "lzma" => "with-xz"
  deprecated_option "zzip" => "with-libzzip"
  deprecated_option "with-fortran" => "with-gcc"

  depends_on "libtool"
  depends_on "gcc" => :optional
  depends_on "libzzip" => :optional
  depends_on "perl" => :optional
  depends_on "php" => :optional
  depends_on "python" => :optional
  depends_on "python@2" => :optional
  depends_on "xz" => :optional

  if build.with?("python") && build.with?("python@2")
    odie "libgetdata: --with-python cannot be specified when using --with-python@2"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--with-perl-dir=#{lib}/perl5/site_perl" if build.with? "perl"
    args << "--without-liblzma" if build.without? "xz"
    args << "--without-libzzip" if build.without? "libzzip"
    args << "--disable-fortran" << "--disable-fortran95" if build.without? "gcc"
    args << "--disable-php" if build.without? "php"

    if build.with?("python") || build.with?("python@2")
      if build.with? "python"
        pyexec = `which python3`.strip
      else
        pyexec = `which python2`.strip
      end
      args << "--with-python=#{pyexec}"
    else
      args << "--disable-python"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
