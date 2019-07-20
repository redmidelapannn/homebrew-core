class Byobu < Formula
  desc "Text-based window manager and terminal multiplexer"
  homepage "https://launchpad.net/byobu"
  url "https://launchpad.net/byobu/trunk/5.129/+download/byobu_5.129.orig.tar.gz"
  sha256 "e5135f20750c359b6371ee87cf2729c6038fbf3a6e66680e67f6a2125b07c2b9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "47c7eafb5ac03719cd52790989b01aab18282502dc8bcb8e41eb091e1df2b7ac" => :mojave
    sha256 "47c7eafb5ac03719cd52790989b01aab18282502dc8bcb8e41eb091e1df2b7ac" => :high_sierra
    sha256 "22212f5dd5f637c8c2136283bf2a6b69b5af5b2f180e1f410c70ac7969c3b6b4" => :sierra
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
