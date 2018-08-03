class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"

  stable do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.8/tcl8.6.8-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.8-src.tar.gz"
    version "8.6.8"
    sha256 "c43cb0c1518ce42b00e7c8f6eaddd5195c53a98f94adc717234a65cbcfd3f96a"

    resource "tk" do
      url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.8/tk8.6.8-src.tar.gz"
      mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tk8.6.8-src.tar.gz"
      version "8.6.8"
      sha256 "49e7bca08dde95195a27f594f7c850b088be357a7c7096e44e1158c7a5fd7b33"

      # Upstream issue 7 Jan 2018 "Build failure with Aqua support on OS X 10.8 and 10.9"
      # See https://core.tcl.tk/tcl/tktview/95a8293a2936e34cc8d0658c21e5214f1ca9b435
      if MacOS.version == :mavericks || MacOS.version == :mountain_lion
        patch :p0 do
          url "https://raw.githubusercontent.com/macports/macports-ports/0a883ad388b/x11/tk/files/patch-macosx-tkMacOSXXStubs.c.diff"
          sha256 "2cdba6bbf2503307fe4f4d7200ad57c9926ebf0ff6ed3e65bf551067a30a04a9"
        end
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "ab13617f4ff2cc8c1d1a1fb8e011b9dc27e0e4afcc73151768c93d32af0992a0" => :high_sierra
    sha256 "5691fa9471de1605a1d975c66aed34b1bad5c64082ad52d9ff974f729d2276b0" => :sierra
    sha256 "f5845a0d76ebeff4269677f1132c19b1abf52d8655b996c89dc7d7689a50b27b" => :el_capitan
  end

  devel do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.7a1/tcl8.7a1-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_7/tk8.7a1-src.tar.gz"
    version "8.7a1"
    sha256 "2bbd4e0bbdebeaf5dc6cc823d0805afb45c764292f6667d9ce2b9fcf5399e0dc"

    resource "tk" do
      url "https://downloads.sourceforge.net/project/tcl/Tcl/8.7a1/tk8.7a1-src.tar.gz"
      mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_7/tk8.7a1-src.tar.gz"
      sha256 "131e4bae43a15dff0324c0479358bb42cfd7b8de0e1ca8d93c9207643c7144dd"
    end
  end

  keg_only :provided_by_macos,
    "tk installs some X11 headers and macOS provides an (older) Tcl/Tk"

  option "without-tcllib", "Don't build tcllib (utility modules)"
  option "without-tk", "Don't build the Tk (window toolkit)"
  option "with-x11", "Build X11-based Tk instead of Aqua-based Tk"

  depends_on :x11 => :optional
  depends_on "pkg-config" => :build if build.with? "x11"

  resource "tcllib" do
    url "https://downloads.sourceforge.net/project/tcllib/tcllib/1.18/tcllib-1.18.tar.gz"
    sha256 "72667ecbbd41af740157ee346db77734d1245b41dffc13ac80ca678dd3ccb515"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-threads
      --enable-64bit
    ]

    cd "unix" do
      system "./configure", *args
      system "make"
      system "make", "install"
      system "make", "install-private-headers"
      ln_s bin/"tclsh#{version.to_f}", bin/"tclsh"
    end

    if build.with? "tk"
      ENV.prepend_path "PATH", bin # so that tk finds our new tclsh

      resource("tk").stage do
        cd "unix" do
          if build.with? "x11"
            system "./configure", *args, "--with-x", "--with-tcl=#{lib}"
          else
            system "./configure", *args, "--enable-aqua=yes",
                                  "--without-x", "--with-tcl=#{lib}"
          end
          system "make"
          system "make", "install"
          system "make", "install-private-headers"
          ln_s bin/"wish#{version.to_f}", bin/"wish"
        end
      end
    end

    if build.with? "tcllib"
      resource("tcllib").stage do
        system "./configure", "--prefix=#{prefix}",
                              "--mandir=#{man}"
        system "make", "install"
      end
    end
  end

  test do
    assert_equal "honk", pipe_output("#{bin}/tclsh", "puts honk\n").chomp
  end
end
