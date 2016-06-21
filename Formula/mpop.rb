class Mpop < Formula
  desc "POP3 client"
  homepage "http://mpop.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mpop/mpop/1.2.4/mpop-1.2.4.tar.xz"
  sha256 "933f6b02afe549d76d0bf631ec97781bd4dd36152fb63d498b82e64e99a11f95"

  bottle do
    cellar :any
    revision 1
    sha256 "ad7de8f311ef59672dfbfe02defb9387ee9287a7d46862d17330c3aa24af48a9" => :el_capitan
    sha256 "52e4b659e035d1b1411a01868e97f57b425e53e4f1bc5bb12141e69b3f4df9c6" => :yosemite
    sha256 "ee91cac07678abe76cefffc7f13e25bf00e8dedf9b2bd34dfbcd3cc48f5c24ca" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpop --version")
  end
end
