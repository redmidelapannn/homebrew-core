class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.2.6.tar.gz"
  sha256 "7e82b7fbfcc698c70f5843bb960dadb8e7bd7ac1d4d2151c9d979372ea850e85"
  revision 3

  bottle do
    rebuild 1
    sha256 "4ecec7d0382f68d3f25170d90310de9008687647d36d9fabd9e8fe282ed5df66" => :sierra
    sha256 "cfb791aa84cba5975a265ae7c35feda5f728508bb4c87d50d70cb963d5c76735" => :el_capitan
    sha256 "4dd91fd05602159858ab85087c6f3c22a189d0095f36cb2ae90e40340d9a9b92" => :yosemite
  end

  devel do
    url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.3.0-rc2/mosh-1.3.0-rc2.tar.gz"
    sha256 "8b6bff33c469ccea0438877c68774a6b2ded6fccd99b1db180222da82f0654ae"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on :perl => "5.14" if MacOS.version <= :mountain_lion
  depends_on "tmux" => :build if build.with?("test") || build.bottle?

  def install
    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
