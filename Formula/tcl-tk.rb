class TclTk < Formula
  desc "Tool Command Language"
  homepage "https://www.tcl.tk/"
  revision 2

  stable do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.6/tcl8.6.6-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.6-src.tar.gz"
    version "8.6.6"
    sha256 "a265409781e4b3edcc4ef822533071b34c3dc6790b893963809b9fe221befe07"

    resource "tk" do
      url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.6/tk8.6.6-src.tar.gz"
      mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tk8.6.6-src.tar.gz"
      version "8.6.6"
      sha256 "d62c371a71b4744ed830e3c21d27968c31dba74dd2c45f36b9b071e6d88eb19d"
    end
  end

  bottle do
    rebuild 1
    sha256 "c91d5790bae7e211389b30f4927d3ace25ccc3bf4c2f650897cccd4eaccd414b" => :sierra
    sha256 "9ee8dbdb83fe00cba13afd413f32a4a5c24d8b33f92e1ceb91e6c55dc4db2025" => :el_capitan
    sha256 "2237a0ff00053b8256e4a389a151dc165baf4acf412427dbe5447b3f89d51fb1" => :yosemite
  end

  devel do
    url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.7/tcl8.6.7rc1-src.tar.gz"
    mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.7rc1-src.tar.gz"
    sha256 "2ca5d7e389482b7d77bf32dd48640437f5e814acfca1dd5ea329dba8250ec720"

    resource "tk" do
      url "https://downloads.sourceforge.net/project/tcl/Tcl/8.6.7/tk8.6.7rc1-src.tar.gz"
      mirror "ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tk8.6.7rc1-src.tar.gz"
      sha256 "8a42af1f250d58bada58bfb6e6d87bdc911d3935b570130c8eb323245d8d90ff"
    end
  end

  keg_only :provided_by_osx,
    "tk installs some X11 headers and macOS provides an (older) Tcl/Tk"

  option "without-tcllib", "Don't build tcllib (utility modules)"
  option "without-tk", "Don't build the Tk (window toolkit)"

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
      ln_s bin/"tclsh8.6", bin/"tclsh"
    end

    if build.with? "tk"
      ENV.prepend_path "PATH", bin # so that tk finds our new tclsh

      resource("tk").stage do
        cd "unix" do
          system "./configure", *args, "--enable-aqua=yes",
                                "--without-x", "--with-tcl=#{lib}"
          system "make"
          system "make", "install"
          system "make", "install-private-headers"
          ln_s bin/"wish8.6", bin/"wish"
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
