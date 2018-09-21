class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.19.0.tar.gz"
  sha256 "2bc8afa16d495a486582bad916d16de1f67c0cce9bb0a35c3123376c2d609480"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "5e8e384575c8a60d84cab59a86b1cd55ded93fe558a7fafbbc7e0e704b415054" => :mojave
    sha256 "9fbfde30e15e96f8b32767d24bf2a563e66b8dc0505dee377ad5db91ae4fc9c3" => :high_sierra
    sha256 "92e647499830d35f79267239f2f531af9a080673f261e79f477fbdb64881d80b" => :sierra
    sha256 "d99cb01e150454f429015051dc39df9d9db238bc82d48ed32200f563525bb409" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libyubikey"

  def install
    libyubikey_prefix = Formula["libyubikey"].opt_prefix
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{libyubikey_prefix}",
                          "--with-backend=osx"
    system "make", "check"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
