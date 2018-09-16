class GnuSmalltalk < Formula
  desc "GNU Smalltalk interpreter and image"
  homepage "http://smalltalk.gnu.org/"
  url "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  revision 7
  head "https://github.com/gnu-smalltalk/smalltalk.git"

  bottle do
    rebuild 1
    sha256 "5a940e8586cdf1c659fd1bc4ea2e2759e38541884fe8066a90545d63bd9bfbd3" => :mojave
    sha256 "68b85f605aa3a4b3393d09b949e20354583792e7ea8003baf4f8ed90f16d51de" => :high_sierra
    sha256 "0a9504a6e93a5773e575dbd8548e2b31b9f6a6f25d4ad03f7cfb93a839487d55" => :sierra
    sha256 "94acc9d39f1214f4045fbfc9d2721c73a366c2b39336382ebecc6863fa81e30e" => :el_capitan
  end

  devel do
    url "https://alpha.gnu.org/gnu/smalltalk/smalltalk-3.2.91.tar.gz"
    mirror "https://www.mirrorservice.org/sites/alpha.gnu.org/gnu/smalltalk/smalltalk-3.2.91.tar.gz"
    sha256 "13a7480553c182dbb8092bd4f215781b9ec871758d1db7045c2d8587e4d1bef9"
  end

  option "with-tcltk", "Build the Tcl/Tk module that requires X11"

  deprecated_option "tcltk" => "with-tcltk"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "pkg-config" => :build
  depends_on "gdbm"
  depends_on "gnutls"
  depends_on "libffi"
  depends_on "libsigsegv"
  depends_on "libtool"
  depends_on "readline"
  depends_on "glew" => :optional
  depends_on :x11 if build.with? "tcltk"

  def install
    ENV.m32 unless MacOS.prefer_64_bit?

    # Fix build failure "Symbol not found: _clock_gettime"
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-lispdir=#{elisp}
      --disable-gtk
      --with-readline=#{Formula["readline"].opt_lib}
    ]

    if build.without? "tcltk"
      args << "--without-tcl" << "--without-tk" << "--without-x"
    end

    # Disable generational gc in 32-bit
    args << "--disable-generational-gc" unless MacOS.prefer_64_bit?

    system "autoreconf", "-ivf"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"test.gst"
    path.write "0 to: 9 do: [ :n | n display ]\n"

    assert_match "0123456789", shell_output("#{bin}/gst #{path}")
  end
end
