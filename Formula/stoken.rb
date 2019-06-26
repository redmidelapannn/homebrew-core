class Stoken < Formula
  desc "Tokencode generator compatible with RSA SecurID 128-bit (AES)"
  homepage "https://stoken.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/stoken/stoken-0.92.tar.gz"
  sha256 "aa2b481b058e4caf068f7e747a2dcf5772bcbf278a4f89bc9efcbf82bcc9ef5a"
  revision 1

  bottle do
    cellar :any
    sha256 "f78407d0c40f9c4476bd0cf596fa3ec2eaf0e75124d038b491440f34c5fa6b95" => :mojave
    sha256 "e2b5ffd565299d6d1d4c7e78e1bc195de80289ea275d99504f6efa348ddc541f" => :high_sierra
    sha256 "08414abd1981e3806efe03d0833911856ca355c4fd55bc529e3c725a5fc385a3" => :sierra
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
