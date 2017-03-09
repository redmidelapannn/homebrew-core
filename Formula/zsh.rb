class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"

  stable do
    url "https://downloads.sourceforge.net/project/zsh/zsh/5.3.1/zsh-5.3.1.tar.gz"
    mirror "https://www.zsh.org/pub/zsh-5.3.1.tar.gz"
    sha256 "3d94a590ff3c562ecf387da78ac356d6bea79b050a9ef81e3ecb9f8ee513040e"

    # We cannot build HTML doc on HEAD, because yodl which is required for
    # building zsh.texi is not available.
    option "with-texi2html", "Build HTML documentation"
    depends_on "texi2html" => [:build, :optional]
  end

  bottle do
    rebuild 1
    sha256 "566ad8316083ac55558001d19e7db88b896a999e2eb03d21bb8ab5621d568440" => :sierra
    sha256 "3e9e4b1367e75525419cd3261b875f907612304e7c7b504bc15d8e8233787815" => :el_capitan
    sha256 "2b3eb0334c7785c29aac74e6a88ff5ff01665125e7aed4f4397dc32f5cb8f9ef" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git"
    depends_on "autoconf" => :build

    option "with-unicode9", "Build with Unicode 9 character width support"
  end

  option "without-etcdir", "Disable the reading of Zsh rc files in /etc"
  option "with-unicode9", "Build with Unicode 9 character width support"

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

  test do
    assert_equal "homebrew\n",
      shell_output("#{bin}/zsh -c 'echo homebrew'")
  end
end
