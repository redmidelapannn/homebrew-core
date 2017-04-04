class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://www.gnu.org/software/ncurses/"
  url "https://ftpmirror.gnu.org/ncurses/ncurses-6.0.tar.gz"
  mirror "https://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz"
  sha256 "f551c24b30ce8bfb6e96d9f59b42fbea30fa3a6123384172f9e7284bcf647260"
  revision 3

  bottle do
    rebuild 1
    sha256 "ee767aac9f9fe0960dfda6c5ba80d3e19be2b09fba4f9ae37e6db31afaa2470e" => :sierra
    sha256 "bb55269af4d9aff25010a0460fa092d493c4182f236a1390cfe0b2dec7806998" => :el_capitan
    sha256 "fbe2aac8ca823e53a1260428714109f0084d2cc1368eb77b0d3014029d71df3e" => :yosemite
  end

  keg_only :provided_by_osx

  depends_on "pkg-config" => :build

  # stable rollup patch created by upstream see
  # http://invisible-mirror.net/archives/ncurses/6.0/README
  resource "ncurses-6.0-20160910-patch.sh" do
    url "http://invisible-mirror.net/archives/ncurses/6.0/ncurses-6.0-20160910-patch.sh.bz2"
    mirror "https://www.mirrorservice.org/sites/lynx.invisible-island.net/ncurses/6.0/ncurses-6.0-20160910-patch.sh.bz2"
    sha256 "f570bcfe3852567f877ee6f16a616ffc7faa56d21549ad37f6649022f8662538"
  end

  def install
    # Fix the build for GCC 5.1
    # error: expected ')' before 'int' in definition of macro 'mouse_trafo'
    # See https://lists.gnu.org/archive/html/bug-ncurses/2014-07/msg00022.html
    # and https://trac.sagemath.org/ticket/18301
    # Disable linemarker output of cpp
    ENV.append "CPPFLAGS", "-P"

    (lib/"pkgconfig").mkpath

    # stage and apply patch
    buildpath.install resource("ncurses-6.0-20160910-patch.sh")
    system "sh", "ncurses-6.0-20160910-patch.sh"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-pc-files",
                          "--with-pkg-config-libdir=#{lib}/pkgconfig",
                          "--enable-sigwinch",
                          "--enable-symlinks",
                          "--enable-widec",
                          "--mandir=#{man}",
                          "--with-manpage-format=normal",
                          "--with-shared",
                          "--with-gpm=no"
    system "make"
    ENV.deparallelize
    system "make", "install"
    make_libncurses_symlinks

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.to_s.split(".")[0]

    %w[form menu ncurses panel].each do |name|
      lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.dylib"
      lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.#{major}.dylib"
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink "libncurses++w.a" => "libncurses++.a"
    lib.install_symlink "libncurses.a" => "libcurses.a"
    lib.install_symlink "libncurses.dylib" => "libcurses.dylib"

    (lib/"pkgconfig").install_symlink "ncursesw.pc" => "ncurses.pc"

    bin.install_symlink "ncursesw#{major}-config" => "ncurses#{major}-config"

    include.install_symlink [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/panel.h", "ncursesw/term.h", "ncursesw/termcap.h"
    ]
  end

  test do
    ENV["TERM"] = "xterm"
    system bin/"tput", "cols"

    system prefix/"test/configure", "--prefix=#{testpath}/test",
                                    "--with-curses-dir=#{prefix}"
    system "make", "install"

    system testpath/"test/bin/keynames"
    system testpath/"test/bin/test_arrays"
    system testpath/"test/bin/test_vidputs"
  end
end
