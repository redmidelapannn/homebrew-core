class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://pagure.io/newt"
  url "https://pagure.io/releases/newt/newt-0.52.18.tar.gz"
  sha256 "771b0e634ede56ae6a6acd910728bb5832ac13ddb0d1d27919d2498dab70c91e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "6f52550722163d9fa062d7086732e187ae8445d5faffeda0c923c8dcccb49ed3" => :sierra
    sha256 "a69af9c6e2d52c958874a75d90e672cf6dafc580798a07d959fa36a365bd33b6" => :el_capitan
    sha256 "d308b3cdd522152464684d96f0356e616f1da7a47132bc792b09bc2c6059702c" => :yosemite
  end

  depends_on "gettext"
  depends_on "popt"
  depends_on "s-lang"

  # build dylibs with -dynamiclib; version libraries
  # Patch via MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/0eb53878/newt/patch-Makefile.in.diff"
    sha256 "6672c253b42696fdacd23424ae0e07af6d86313718e06cd44e40e532a892db16"
  end

  def install
    args = ["--prefix=#{prefix}", "--without-tcl"]

    inreplace "Makefile.in" do |s|
      # name libraries correctly
      # https://bugzilla.redhat.com/show_bug.cgi?id=1192285
      s.gsub! "libnewt.$(SOEXT).$(SONAME)", "libnewt.$(SONAME).dylib"
      s.gsub! "libnewt.$(SOEXT).$(VERSION)", "libnewt.$(VERSION).dylib"

      # don't link to libpython.dylib
      # causes https://github.com/Homebrew/homebrew/issues/30252
      # https://bugzilla.redhat.com/show_bug.cgi?id=1192286
      s.gsub! "`$$pyconfig --ldflags`", '"-undefined dynamic_lookup"'
      s.gsub! "`$$pyconfig --libs`", '""'
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    system "python", "-c", "import snack"
    (testpath/"test.c").write <<-EOS.undent
      #import <newt.h>
      int main() {
        newtInit();
        newtFinished();
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-lnewt"
    system "./test"
  end
end
