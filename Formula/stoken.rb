class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"

  bottle do
    cellar :any
    rebuild 2
    sha256 "52597e27ca6e2ee6376cafcf4cd15e59291ffe836997cc2b5f915f6724574203" => :catalina
    sha256 "5f2101d086ae4a4e903ab65c0f72c44514b412549058581b07304104d2c4ed0f" => :mojave
    sha256 "619554d1910a8f01d4bb0504b31b9d1447c8e5d4e419772a31a89062a1b7c52a" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "nettle"
  uses_from_macos "libxml2"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/stoken", "show", "--random"
  end
end
