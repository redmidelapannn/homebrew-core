class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "http://byobu.co/"
  url "https://launchpad.net/byobu/trunk/5.127/+download/byobu_5.127.orig.tar.gz"
  sha256 "4bafc7cb69ff5b0ab6998816d58cd1ef7175e5de75abc1dd7ffd6d5288a4f63b"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f369b8fd147fec07fcee9ea20e1186b4656745f69d236850c7e181caddf3335" => :high_sierra
    sha256 "1f369b8fd147fec07fcee9ea20e1186b4656745f69d236850c7e181caddf3335" => :sierra
    sha256 "1f369b8fd147fec07fcee9ea20e1186b4656745f69d236850c7e181caddf3335" => :el_capitan
  end

  head do
    url "https://github.com/dustinkirkland/byobu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "coreutils"
  depends_on "gnu-sed" # fails with BSD sed
  depends_on "tmux"
  depends_on "newt"

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
