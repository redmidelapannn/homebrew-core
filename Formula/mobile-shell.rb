class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.2.6.tar.gz"
  sha256 "7e82b7fbfcc698c70f5843bb960dadb8e7bd7ac1d4d2151c9d979372ea850e85"
  revision 3

  bottle do
    rebuild 1
    sha256 "8bd6e4f953ded79712c4805ede92b1d7f5dd122cf77ccfafaafc52debab8bc56" => :sierra
    sha256 "7617c7b143296750a74afed14ee0243d921f35c14b3b83696eff24180824e60a" => :el_capitan
    sha256 "090351e0e775a91472adf6b79e816051783a05071b08f8476676a2845c22a9f6" => :yosemite
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
    # Fix for 'dyld: lazy symbol binding failed: Symbol not found: _clock_gettime' issue
    # Reported 26 Sep 2016 https://github.com/mobile-shell/mosh/issues/807
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_search_clock_gettime"] = "no"
    end

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
