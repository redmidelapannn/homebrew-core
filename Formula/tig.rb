class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.3.0/tig-2.3.0.tar.gz"
  sha256 "686f0386927904dc6410f0b1a712cb8bd7fff3303f688d7dc43162f4ad16c0ed"

  bottle do
    rebuild 1
    sha256 "86e2cda8951bfdb9b20a3a85f2ce90767d8162e06efc5e3371b818309a0ca4f3" => :high_sierra
    sha256 "ef548480e5a108805f968bbf14c47b250a05eeb7ac197750657855d41fb14725" => :sierra
    sha256 "bc1f057b160d09c3bc84d2f07645b3d5a04d8591c7be279debadbe08995a62ce" => :el_capitan
  end

  head do
    url "https://github.com/jonas/tig.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-docs", "Build man pages using asciidoc and xmlto"

  if build.with? "docs"
    depends_on "asciidoc"
    depends_on "xmlto"
  end

  depends_on "readline" => :recommended
  depends_on "ncurses" => :recommended

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    # Ensure the configured `sysconfdir` is used during runtime by
    # installing in a separate step.
    system "make", "install", "sysconfdir=#{pkgshare}/examples"
    system "make", "install-doc-man" if build.with? "docs"
    bash_completion.install "contrib/tig-completion.bash"
    zsh_completion.install "contrib/tig-completion.zsh" => "_tig"
    cp "#{bash_completion}/tig-completion.bash", zsh_completion
  end

  def caveats; <<-EOS.undent
    A sample of the default configuration has been installed to:
      #{opt_pkgshare}/examples/tigrc
    to override the system-wide default configuration, copy the sample to:
      #{etc}/tigrc
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tig -v")
  end
end
