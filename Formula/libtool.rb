# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  sha256 "7c87a8c2c8c0fc9cd5019e402bed4292462d00a718a7cd5f11218153bf28b26f"

  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "42453e5e53890ac58539333cd3399628cfa63f1314f609073a35194f78ee2cce" => :high_sierra
    sha256 "5b6cbe4567e18e9b759f331d39b578cf5fc2d42c875e3260930cca82af8e3534" => :sierra
    sha256 "204f036c0e00fd871e57f5450302df1c1896005174d627515f2dfef8d641c6fb" => :el_capitan
  end

  keg_only :provided_until_xcode43

  def install
    ENV["SED"] = "sed" # prevent libtool from hardcoding sed path from superenv
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--program-prefix=g",
                          "--enable-ltdl-install"
    system "make", "install"
    # Symlink all commands into libexec/gnubin without the 'g' prefix
    libtool_filenames(bin).each do |cmd|
      (libexec/"bin").install_symlink bin/"g#{cmd}" => cmd
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    libtool_filenames(man1).each do |cmd|
      (libexec/"man"/"man1").install_symlink man1/"g#{cmd}" => cmd
    end
  end

  def caveats; <<~EOS
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.

    If you really need to use these commands with their normal names, you
    can add a "libtool/libexec/bin" directory to your PATH from your bashrc like:

        PATH="#{opt_libexec}/bin:$PATH"

    Additionally, you can access their man pages with normal names if you add
    the "libtool/libexec/man" directory to your MANPATH from your bashrc as well:

        MANPATH="#{opt_libexec}/man:$MANPATH"

    EOS
  end

  def libtool_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"
      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
    (testpath/"hello.c").write <<-EOS
      #include <stdio.h>
      int main() { puts("Hello, world!"); return 0; }
    EOS
    system bin/"glibtool", "--mode=compile", "--tag=CC",
      ENV.cc, "-c", "hello.c", "-o", "hello.o"
    system bin/"glibtool", "--mode=link", "--tag=CC",
      ENV.cc, "hello.o", "-o", "hello"
    assert_match "Hello, world!", shell_output("./hello")
  end
end
