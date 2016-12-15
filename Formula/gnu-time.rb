class GnuTime < Formula
  desc "GNU implementation of time utility"
  homepage "https://www.gnu.org/software/time/"
  url "https://ftpmirror.gnu.org/time/time-1.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/time/time-1.7.tar.gz"
  sha256 "e37ea79a253bf85a85ada2f7c632c14e481a5fd262a362f6f4fd58e68601496d"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "df791664998a5e973391b7c985f33068e5994b679c124de72a189916f1770e3f" => :sierra
    sha256 "f7bef32e901dfe412a7fa3126ba29988a628d5ce341091a14609536c596d7f84" => :el_capitan
    sha256 "67cc37f7fb8b46bfe6d8ca1d8366fedaf7bedd3b4d83e98f40cd7223fd4fb0ac" => :yosemite
  end

  option "with-default-names", "Do not prepend 'g' to the binary"

  # Fixes issue with main returning void rather than int
  # https://trac.macports.org/ticket/32860
  # https://trac.macports.org/browser/trunk/dports/sysutils/gtime/files/patch-time.c.diff?rev=88924
  patch :DATA

  def install
    args = [
      "--prefix=#{prefix}",
      "--mandir=#{man}",
      "--info=#{info}",
    ]

    args << "--program-prefix=g" if build.without? "default-names"

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<-EOS.undent
    If you compiled "with-default-names" and you use zsh, then
    this command will be overshadowed by a built-in. To fix this,
    add the following to your .zshrc:

        ## Disable builtin `time` command so that gnu-time may be used instead
        if ! [ -x "$(which time)" ] ;then disable -r time ; fi

    EOS
  end

  test do
    system bin/"gtime", "ruby", "--version"
  end
end

__END__
diff --git a/time.c b/time.c
index 9d5cf2c..97611f5 100644
--- a/time.c
+++ b/time.c
@@ -628,7 +628,7 @@ run_command (cmd, resp)
   signal (SIGQUIT, quit_signal);
 }
 
-void
+int
 main (argc, argv)
      int argc;
      char **argv;
