class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "http://xplanet.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"

  bottle do
    rebuild 2
    sha256 "e8b6f5be2ca55ed4a7930fc69da35286787e0b42956b0be09363fbc1d41401b4" => :sierra
    sha256 "e379c16c886106d062677a08418e6d74488e2400c9158f99348a4701abb7173b" => :el_capitan
    sha256 "d2b9551a91384b8c2425e37aa64b3507991dd578cdfadfee36926e7704938692" => :yosemite
  end

  option "with-x11", "Build for X11 instead of Aqua"
  option "with-all", "Build with default Xplanet configuration dependencies"
  option "with-pango", "Build Xplanet to support Internationalized text library"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"

  depends_on "pkg-config" => :build

  depends_on "giflib" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  if build.with?("all")
    depends_on "netpbm"
    depends_on "pango"
    depends_on "cspice"
  end

  depends_on "netpbm" => :optional
  depends_on "pango" => :optional
  depends_on "cspice" => :optional

  depends_on "freetype"
  depends_on :x11 => :optional

  # patches bug in 1.3.1 with flag -num_times=2 (1.3.2 will contain fix, when released)
  # https://sourceforge.net/p/xplanet/code/208/tree/trunk/src/libdisplay/DisplayOutput.cpp?diff=5056482efd48f8457fc7910a:207
  patch :p2 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/f952f1d/xplanet/xplanet-1.3.1-ntimes.patch"
    sha256 "3f95ba8d5886703afffdd61ac2a0cd147f8d659650e291979f26130d81b18433"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-cygwin
    ]

    if build.without?("all")
      args << "--without-gif" if build.without?("giflib")
      args << "--without-jpeg" if build.without?("jpeg")
      args << "--without-libpng" if build.without?("libpng")
      args << "--without-libtiff" if build.without?("libtiff")
      args << "--without-pnm" if build.without?("netpbm")
      args << "--without-pango" if build.without?("pango")
      args << "--without-cspice" if build.without?("cspice")
    end

    if build.with?("x11")
      args << "--with-x" << "--with-xscreensaver" << "--without-aqua"
    else
      args << "--with-aqua" << "--without-x" << "--without-xscreensaver"
    end

    if build.with?("netpbm") || build.with?("all")
      netpbm = Formula["netpbm"].opt_prefix
      ENV.append "CPPFLAGS", "-I#{netpbm}/include/netpbm"
      ENV.append "LDFLAGS", "-L#{netpbm}/lib"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/xplanet", "-geometry", "4096x2160", "-projection", "mercator", "-gmtlabel", "-num_times", "1", "-output", "#{testpath}/xp-test.png"
  end
end
