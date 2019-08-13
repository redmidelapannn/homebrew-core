class Zsh < Formula
  desc "UNIX shell (command interpreter)"
  homepage "https://www.zsh.org/"
  url "https://downloads.sourceforge.net/project/zsh/zsh/5.7.1/zsh-5.7.1.tar.xz"
  mirror "https://www.zsh.org/pub/zsh-5.7.1.tar.xz"
  sha256 "7260292c2c1d483b2d50febfa5055176bd512b32a8833b116177bf5f01e77ee8"

  bottle do
    rebuild 1
    sha256 "54f7fdfce09928a7f79ceb129d7b28651ad1d25472f2a9cf1a8a55a16bc69477" => :mojave
    sha256 "9c0f008250e07ce87da1de08ca661d9d3078a74933b151b84ca5325acc430432" => :high_sierra
    sha256 "a2bad790be275767f1a9878240129fe3fdb0cc311542e2f85f88de255e3259f3" => :sierra
  end

  head do
    url "https://git.code.sf.net/p/zsh/code.git"
    depends_on "autoconf" => :build
  end

  depends_on "ncurses"
  depends_on "pcre"

  resource "htmldoc" do
    url "https://downloads.sourceforge.net/project/zsh/zsh-doc/5.7.1/zsh-5.7.1-doc.tar.xz"
    mirror "https://www.zsh.org/pub/zsh-5.7.1-doc.tar.xz"
    sha256 "3053670250e23905c940592c79428d7f67495fa05b0fff49dfaab9172c4239b4"
  end

  def install
    system "Util/preconfig" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-fndir=#{pkgshare}/functions",
                          "--enable-scriptdir=#{pkgshare}/scripts",
                          "--enable-site-fndir=#{HOMEBREW_PREFIX}/share/zsh/site-functions",
                          "--enable-site-scriptdir=#{HOMEBREW_PREFIX}/share/zsh/site-scripts",
                          "--enable-runhelpdir=#{pkgshare}/help",
                          "--enable-cap",
                          "--enable-maildir-support",
                          "--enable-multibyte",
                          "--enable-pcre",
                          "--enable-zsh-secure-free",
                          "--enable-unicode9",
                          "--enable-etcdir=/etc",
                          "--with-tcsetpgrp",
                          "DL_EXT=bundle"

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

      resource("htmldoc").stage do
        (pkgshare/"htmldoc").install Dir["Doc/*.html"]
      end
    end
  end

  def caveats; <<~EOS
    You will need to add:
      #{bin}/zsh
    to /etc/shells.

    Then run:
      chsh -s #{bin}/zsh
    to make zsh your default shell.
  EOS
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}/zsh -c 'echo homebrew'").chomp
    system bin/"zsh", "-c", "printf -v hello -- '%s'"
  end
end
