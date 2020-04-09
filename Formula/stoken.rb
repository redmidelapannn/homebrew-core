class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"
  revision 1

  bottle do
    cellar :any
    sha256 "12ace52f622b41cf259e6062cad2e18707ca296dd920e27e4d14cbe34f5755a7" => :catalina
    sha256 "b0a7a9a3af185ff5d7401c7838a9e63cc25bf90d59557ef8db534212cbcf3778" => :mojave
    sha256 "3668f8eefebfbcdb76f416d8cd01b0c443672b5ac6453d1559e729bbde9a8d94" => :high_sierra
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
