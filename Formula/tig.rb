class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "http://jonas.nitro.dk/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.2.1/tig-2.2.1.tar.gz"
  sha256 "0b48080896de59179c45c980080b4b414bb235df65ad08d661a9c9e169c3fa71"

  bottle do
    rebuild 1
    sha256 "de9c520f3fba4bc4c6fe3d0eeb6eb9b3f0204c290b84bf5cc1bc6c07d18ef1d7" => :sierra
    sha256 "3c14899d43e7e10a61c744a67cc6b219ba1ba63565a0240c6d36e53dd553bf14" => :el_capitan
    sha256 "5fc52a7d8bfb4d3ac02dd2a7522dbd186b2e21b78d2c0675222ea2eefb65a780" => :yosemite
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
