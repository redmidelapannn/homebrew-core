class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://github.com/tmux/tmux/releases/download/2.2/tmux-2.2.tar.gz"
  sha256 "bc28541b64f99929fe8e3ae7a02291263f3c97730781201824c0f05d7c8e19e4"

  bottle do
    cellar :any
    sha256 "1fa3746741844e4eaf91f34f3c611e7193ba8d0b916c9c6624561b2c18e97063" => :el_capitan
    sha256 "eb646d1d121703d1c111b0c93b14a30842f441913f0ffd2bb48330a3d79ece86" => :yosemite
    sha256 "23cec80634633336c0654b6b6e85ed8c1e852f82e618279358bae3283ed08fb4" => :mavericks
  end

  head do
    url "https://github.com/tmux/tmux.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  resource "completion" do
    url "https://raw.githubusercontent.com/przepompownia/tmux-bash-completion/v0.0.1/completions/tmux"
    sha256 "a0905c595fec7f0258fba5466315d42d67eca3bd2d3b12f4af8936d7f168b6c6"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    ENV.append "LDFLAGS", "-lresolv"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"

    system "make", "install"

    pkgshare.install "example_tmux.conf" if build.head?

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
