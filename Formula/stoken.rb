class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"
  revision 1

  bottle do
    cellar :any
    sha256 "ab6798dfe9bdb43eb98fdef5f21c9b45a53e65e26c16fffbf6de862e7606e6e2" => :catalina
    sha256 "d1b01f80fee156b9128320ecd5bd88cd07b0dbbe0f4331cfa132b4af98e20f81" => :mojave
    sha256 "89554cfa0484f2351b3bceafb7ccb6a3f0f391e2101c663465e6251b74b715c3" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "nettle"

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
