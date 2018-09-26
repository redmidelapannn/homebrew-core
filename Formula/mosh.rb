class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.3.2.tar.gz"
  sha256 "da600573dfa827d88ce114e0fed30210689381bbdcff543c931e4d6a2e851216"
  revision 4

  bottle do
    rebuild 1
    sha256 "3bdc0ce1ea28d7c72cad8798c959efdb6302a1e359201ea45c60ff2e4d230662" => :mojave
    sha256 "44e46669e1a356253c17b4d17440f51639141103132fb16b526c34cba92e4b2b" => :high_sierra
    sha256 "f46623b09036a53acf4cbdedaf0fb15e5c4e61473b070f3fe1c0a823edbb0558" => :sierra
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "tmux" => :build if build.bottle?
  depends_on "protobuf"

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
