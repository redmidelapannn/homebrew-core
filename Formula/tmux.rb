class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.9a/tmux-2.9a.tar.gz"
  sha256 "839d167a4517a6bffa6b6074e89a9a8630547b2dea2086f1fad15af12ab23b25"
  revision 2

  bottle do
    cellar :any
    sha256 "a48fe0509700a575dda449526f4815bc200b165e01ab5454d2cd8c6988926fe6" => :catalina
    sha256 "dbbbf4ff7f37836d493c0d9c57dfc0d3ce12586c4e4f529db85b922b81416d89" => :mojave
    sha256 "6b86d16d31f4852ccae7f2ad8716ac81a72639bf89db7bcedc000ac80e897e73" => :high_sierra
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"

  resource "completion" do
    url "https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/homebrew_1.0.0/completions/tmux"
    sha256 "05e79fc1ecb27637dc9d6a52c315b8f207cf010cdcee9928805525076c9020ae"
  end

  # Backport tmux server crash fix in sitations when
  # main-horizontal layout contains splits that are overflowing text
  #
  # Ref: https://github.com/tmux/tmux/issues/1811
  #
  # To be removed upon formula bump to 3.0
  patch do
    url "https://github.com/tmux/tmux/commit/38b8a198bac62c16d351c54ed83ead29a2e0ecc8.patch?full_index=1"
    sha256 "06cea85b4d081fbd52b083d390d51433e11c6c1955d1d66c2ffa20b247ad2c8a"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --disable-Dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", *args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats; <<~EOS
    Example configuration has been installed to:
      #{opt_pkgshare}
  EOS
  end

  test do
    system "#{bin}/tmux", "-V"
  end
end
