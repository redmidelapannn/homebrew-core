class Newt < Formula
  desc "Library for color text mode, widget based user interfaces"
  homepage "https://fedorahosted.org/newt/"
  url "https://fedorahosted.org/releases/n/e/newt/newt-0.52.18.tar.gz"
  sha256 "771b0e634ede56ae6a6acd910728bb5832ac13ddb0d1d27919d2498dab70c91e"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "daf9e3df2f99a5cde56bbcb3622f3a092d83067baacc89c0297c519fd24c1ae3" => :sierra
    sha256 "eb579dcf82f89296a1f3ed7b4348448b327ded51089fe7e498c14304b2cf93b6" => :el_capitan
    sha256 "e300c94ad64235cbf929a397805ca8d7eec24484f69cc4853554ca75b036c0ef" => :yosemite
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
