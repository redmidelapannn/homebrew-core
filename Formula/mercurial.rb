# No head build supported; if you need head builds of Mercurial, do so outside
# of Homebrew.
class Mercurial < Formula
  desc "Scalable distributed version control system"
  homepage "https://mercurial-scm.org/"
  url "https://mercurial-scm.org/release/mercurial-4.2.tar.gz"
  sha256 "23a412308fc9c2b354a0e91a89588a4af2af061b47da80bc4233ccb0cceef47d"

  head "https://www.mercurial-scm.org/repo/hg/archive/tip.tar.gz"

  bottle do
    rebuild 1
    sha256 "43819eacb6604a82ebd2bbc0378092c3285e9eea7eb45cebecf545580ccf2448" => :sierra
    sha256 "08da4621106f757643434f9a23a97b8b6585ec7c3da595681b36cb337cb730e0" => :el_capitan
    sha256 "ca4e23992aae4334083a58becb9a926fa459ce021b201ddb20f3c9b33dc80cac" => :yosemite
  end

  option "with-custom-python", "Install against the python in PATH instead of Homebrew's python"
  depends_on :python

  def install
    system "make", "PREFIX=#{prefix}", "install-bin"

    # Install chg (see https://www.mercurial-scm.org/wiki/CHg)
    cd "contrib/chg" do
      system "make", "PREFIX=#{prefix}", "HGPATH=#{bin}/hg", \
             "HG=#{bin}/hg"
      bin.install "chg"
    end

    # Configure a nicer default pager
    (buildpath/"hgrc").write <<-EOS.undent
      [pager]
      pager = less -FRX
    EOS

    (etc/"mercurial").install "hgrc"

    # Install man pages, which come pre-built in source releases
    if build.stable?
      man1.install "doc/hg.1"
      man5.install "doc/hgignore.5", "doc/hgrc.5"
    end

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
