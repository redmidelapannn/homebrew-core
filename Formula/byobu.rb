class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://launchpad.net/byobu"
  url "https://launchpad.net/byobu/trunk/5.130/+download/byobu_5.130.orig.tar.gz"
  sha256 "47e414161dda124287b9ec1cf94acc716b49e7428c6ec7efeed181f477e17461"

  bottle do
    cellar :any_skip_relocation
    sha256 "3fc6479c9f8ade7976cb70a62eff7aae03cb660f9dc1fc053e1cfe63d8cdf065" => :catalina
    sha256 "6d47abdde37ae912d3ffabf2161284914cd5cd75ec68b2308e14f1e7cc560e1e" => :mojave
    sha256 "6d47abdde37ae912d3ffabf2161284914cd5cd75ec68b2308e14f1e7cc560e1e" => :high_sierra
    sha256 "2071147e4d137922442b615dfe4bc13513b85ba1766aa36c7367aec29097ec2c" => :sierra
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "newt"
  depends_on "tmux"

  conflicts_with "ctail", :because => "both install `ctail` binaries"

  def install
    if build.head?
      cp "./debian/changelog", "./ChangeLog"
      system "autoreconf", "-fvi"
    end
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<~EOS
    Add the following to your shell configuration file:
      export BYOBU_PREFIX=#{HOMEBREW_PREFIX}
  EOS
  end

  test do
    system bin/"byobu-status"
  end
end
