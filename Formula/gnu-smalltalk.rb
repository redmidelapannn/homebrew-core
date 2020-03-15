class GnuSmalltalk < Formula
  desc "GNU Smalltalk interpreter and image"
  homepage "http://smalltalk.gnu.org/"
  url "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  revision 9
  head "https://github.com/gnu-smalltalk/smalltalk.git"

  bottle do
    sha256 "10812e55e9f0f568eb9d1327728d084c6dff00a1bd2ec4868290f4a492c91c01" => :catalina
    sha256 "d4eead8c0db3c26df40254c71c8188c5cdf54c9733206da1ec3aaf37713ef597" => :mojave
    sha256 "b1cea1934347e8a261616ce0c248a4ccd902799c6b5f2ff30569e67d1dc02975" => :high_sierra
  end

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

  def install
    # Fix build failure "Symbol not found: _clock_gettime"
    ENV["ac_cv_search_clock_gettime"] = "no" if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-lispdir=#{elisp}
      --disable-gtk
      --with-readline=#{Formula["readline"].opt_lib}
      --without-tcl
      --without-tk
      --without-x
    ]

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
