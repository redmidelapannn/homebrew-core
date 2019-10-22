class Ori < Formula
  desc "Secure distributed file system"
  homepage "http://ori.scs.stanford.edu/"
  url "https://bitbucket.org/orifs/ori/downloads/ori-0.8.2.tar.xz"
  sha256 "a9b12ac23beaf259aa830addea11b519d16068f38c479f916b2747644194672c"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "5b78d0d85bfe3059db40849f5e5b658417f770dec50e78f52921f4b5cd05411a" => :catalina
    sha256 "18d65d0a15d0c7696c06db6a70612be6bd72594fe81fbd25504dced2cec7a881" => :mojave
    sha256 "a8305091ad243979358fe24b3c0d93c2dfddb03b753374cfdb68481dff835adf" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "scons" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on :osxfuse

  # Patch adapted from upstream for OpenSSL 1.1 compatibility
  # https://bitbucket.org/orifs/ori/pull-requests/7/adjust-to-libssl-api-changes-from-10-to-11/diff
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/ori/openssl-1.1.diff"
    sha256 "234448ebdf393723fb077960e66c3f5768c93989f9d169816f17600ef64e8219"
  end

  def install
    system "scons", "BUILDTYPE=RELEASE"
    system "scons", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/ori"
  end
end
