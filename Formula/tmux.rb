class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5.tar.gz"
  sha256 "ae135ec37c1bf6b7750a84e3a35e93d91033a806943e034521c8af51b12d95df"

  bottle do
    rebuild 1
    sha256 "cdb96c763f8829253728c5afa04abb48602110be2d0a452d15f5e9fcadb6fe53" => :sierra
    sha256 "46a22a9a9e0224e70e371880c09fbfb07c366990f9f5071f21a19d586d0f13c2" => :el_capitan
    sha256 "96b990c4ce038bd8be606c87788855a809479476c1437a1952db8fdbaf9d3406" => :yosemite
  end

  devel do
    url "https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6-rc.tar.gz"
    sha256 "96ddc4e5d8a4dbd5bd1eea841e0c9d7a0484ae01e7e0de6857c5dbc7e69aaada"
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "utf8proc" => :optional

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --disable-Dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--enable-utf8proc" if build.with?("utf8proc")

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats; <<-EOS.undent
    Example configuration has been installed to:
      #{opt_pkgshare}
    EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
