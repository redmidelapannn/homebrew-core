class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.2.tar.gz"
  sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"
  revision 5

  bottle do
    sha256 "6ceee6f1c8feda5910ad597c53d10c2d1b9104b71193a05fd785607d504449f6" => :mojave
    sha256 "d71ce14e4da48c618923ca7940665c74c26b6876577a4d7d3c3dcdc3716e68fa" => :high_sierra
    sha256 "95dc6b2cd6422e60d8d60d670ab90c1b5be54e9666d4389b8638476cba622dfc" => :sierra
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "tmux" => :build if build.bottle?
  depends_on "protobuf" => ['without-python@2']

  needs :cxx11

  def install
    ENV.cxx11

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
