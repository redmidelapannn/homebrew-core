class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.4.1/tig-2.4.1.tar.gz"
  sha256 "b6b6aa183e571224d0e1fab3ec482542c1a97fa7a85b26352dc31dbafe8558b8"

  bottle do
    rebuild 1
    sha256 "d7d2db4e38d9fcf995f65579b389ecd213f9843c53e851311c1307af2e88aa49" => :mojave
    sha256 "48268306859f1b365fbf11f1314dae93ffb8e6532ba2844d6d30f1fd277c97ae" => :high_sierra
    sha256 "d2054fd8548fe2ce61e736f5740fee6d6669789dac6df71053204b61be557f10" => :sierra
    sha256 "40a7651c6648dcb7ed23aaddab0dfa7d9b29465598d1f527507b8f0aa55cb869" => :el_capitan
  end

  head do
    url "https://github.com/jonas/tig.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    # Ensure the configured `sysconfdir` is used during runtime by
    # installing in a separate step.
    system "make", "install", "sysconfdir=#{pkgshare}/examples"
    system "make", "install-doc-man"
    bash_completion.install "contrib/tig-completion.bash"
    zsh_completion.install "contrib/tig-completion.zsh" => "_tig"
    cp "#{bash_completion}/tig-completion.bash", zsh_completion
  end

  def caveats; <<~EOS
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
