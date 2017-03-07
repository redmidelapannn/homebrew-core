# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.1.1.tar.gz"
  sha256 "63571be1202f83c72041eb8ca2a2ebaeda284d2031fd708919fc610589d3359e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bc405059994f9f4c2b9a4a4ba6fa9ebf1ee8f449d3b6c799369b982a51d4249b" => :sierra
    sha256 "0d051e124a2141935f0e11cbeb94e2faf65795c0081db90ba12191242865f32c" => :el_capitan
    sha256 "387e0348940e16f8affa80d2c8ee75ca9c513e7f38101d5e4154c89d2a938f4d" => :yosemite
  end

  option "with-custom-python", "Install against the python in PATH instead of Homebrew's python"
  depends_on :python

  def install
    system "make", "PREFIX=#{prefix}", "install-bin"
    # Install man pages, which come pre-built in source releases
    man1.install "doc/hg.1"
    man5.install "doc/hgignore.5", "doc/hgrc.5"

    # install the completion scripts
    bash_completion.install "contrib/bash_completion" => "hg-completion.bash"
    zsh_completion.install "contrib/zsh_completion" => "_hg"
  end

  def caveats
    return unless (opt_bin/"hg").exist?
    cacerts_configured = `#{opt_bin}/hg config web.cacerts`.strip
    return if cacerts_configured.empty?
    <<-EOS.undent
      Homebrew has detected that Mercurial is configured to use a certificate
      bundle file as its trust store for TLS connections instead of using the
      default OpenSSL store. If you have trouble connecting to remote
      repositories, consider unsetting the `web.cacerts` property. You can
      determine where the property is being set by running:
        hg config --debug web.cacerts
    EOS
  end

  test do
    system "#{bin}/hg", "init"
  end
end
