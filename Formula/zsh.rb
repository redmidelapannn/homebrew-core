class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"

  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.2/zsh-5.2.tar.gz"
    mirror "https://www.zsh.org/pub/zsh-5.2.tar.gz"
    sha256 "fa924c534c6633c219dcffdcd7da9399dabfb63347f88ce6ddcd5bb441215937"

    # We cannot build HTML doc on HEAD, because yodl which is required for
    # building zsh.texi is not available.
    option "with-texi2html", "Build HTML documentation"
    depends_on "texi2html" => [:build, :optional]

    # apply patch that fixes nvcsformats which is broken in zsh-5.2 and will propably be fixed in 5.2.1
    # See https://github.com/zsh-users/zsh/commit/4105f79a3a9b5a85c4ce167865e5ac661be160dc
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/master/zsh/nvcs-formats-fix.patch"
      sha256 "f351cd67d38b9d8a9c2013ae47b77a753eca3ddeb6bfd807bd8b492516479d94"
    end
  end

  bottle do
    rebuild 4
    sha256 "c93a9ce38c4aa40127efaba5f70c30228d9957c726757f7102778338e37f3ad4" => :sierra
    sha256 "8f348a158d6c19919c9d435c2afc75662accc887c38cd4d756d10f05fbd96bfa" => :el_capitan
    sha256 "2502e0c437d5c00ca827e913c181ce61e85cd4ef934bf2ab814b6d2a1165e9cb" => :yosemite
  end

  devel do
    url "http://www.zsh.org/pub/development/zsh-5.2-test-3.tar.gz"
    version "5.2-test-3"
    sha256 "7d486688d77c98b2a9bb8d8d6283d780c0e0ac64b1226dddb3fc9bcca5bcfcc3"

    option "with-texi2html", "Build HTML documentation"
    option "with-unicode9", "Build with Unicode 9 character width support"
    depends_on "texi2html" => [:build, :optional]
  end

  head do
    url "git://git.code.sf.net/p/zsh/code"
    depends_on "autoconf" => :build

    option "with-unicode9", "Build with Unicode 9 character width support"
  end

  option "without-etcdir", "Disable the reading of Zsh rc files in /etc"

  deprecated_option "disable-etcdir" => "without-etcdir"

  depends_on "gdbm"
  depends_on "pcre"

  def install
    system "Util/preconfig" if build.head?

    args = %W[
      --prefix=#{prefix}
      --enable-fndir=#{pkgshare}/functions
      --enable-scriptdir=#{pkgshare}/scripts
      --enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions
      --enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts
      --enable-runhelpdir=#{pkgshare}/help
      --enable-cap
      --enable-maildir-support
      --enable-multibyte
      --enable-pcre
      --enable-zsh-secure-free
      --with-tcsetpgrp
    ]

    args << "--enable-unicode9" if build.with? "unicode9"

    if build.without? "etcdir"
      args << "--disable-etcdir"
    else
      args << "--enable-etcdir=/etc"
    end

    system "./configure", *args

    # Do not version installation directories.
    inreplace ["Makefile", "Src/Makefile"],
      "$(libdir)/$(tzsh)/$(VERSION)", "$(libdir)"

    if build.head?
      # disable target install.man, because the required yodl comes neither with macOS nor Homebrew
      # also disable install.runhelp and install.info because they would also fail or have no effect
      system "make", "install.bin", "install.modules", "install.fns"
    else
      system "make", "install"
      system "make", "install.info"
      system "make", "install.html" if build.with? "texi2html"
    end
  end

  def caveats; <<-EOS.undent
    In order to use this build of zsh as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    assert_equal "homebrew\n",
      shell_output("#{bin}/zsh -c 'echo homebrew'")
  end
end
