class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.18.0.tar.gz"
  sha256 "cf333e133b551adf5963e0f5fe0566f4e397f9784d4c1b8fc56b9d2ebcf982ad"
  revision 1

  bottle do
    cellar :any
    sha256 "23989aa8fcd8edf626ae7bf53d977f0891b3e04f653f7f2a45210f5e4fc86134" => :high_sierra
    sha256 "649eae231982bc1cb318186bc990fff96f46f2b37e6a3295887142629d09086a" => :sierra
    sha256 "20d7a680047df7f528f4bd22f5bd4617e84f28b433cda06f02eb1d2e9a906968" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libyubikey"
  depends_on "json-c" => :recommended

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
