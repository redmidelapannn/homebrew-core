class Tig < Formula
  desc "Text interface for Git repositories"
  homepage "https://jonas.github.io/tig/"
  url "https://github.com/jonas/tig/releases/download/tig-2.3.2/tig-2.3.2.tar.gz"
  sha256 "6410e51c6149d76eac3510d04f9a736139f85e7c881646937d009caacf98cff1"
  revision 1

  bottle do
    rebuild 1
    sha256 "45bbeb1b3e32d441874d7a81eac8bffe3dca6b8978d47878f56df3fe297e909a" => :high_sierra
    sha256 "8793e824f4d44b06ffdc81189d5a9e8919bbd16b9e7a8097aca5a25e3399fdd1" => :sierra
    sha256 "a4b4a9dd22f247257423afe721f6e46292df16bf0e13d4a4b395d7edf9d3ecf6" => :el_capitan
  end

  head do
    url "https://github.com/jonas/tig.git"

    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  depends_on "readline" => :recommended

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
