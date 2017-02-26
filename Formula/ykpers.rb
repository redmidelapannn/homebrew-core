class Ykpers < Formula
  desc "YubiKey personalization library and tool"
  homepage "https://developers.yubico.com/yubikey-personalization/"
  url "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-1.17.3.tar.gz"
  sha256 "482fc3984fc659c801cfc51313268f248507094ed5224f4394cfd66e23af9c0c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "609c5f03b4c19f7ef3248545f46a7c282fa20563ba43d68cb4c0571287ce078b" => :sierra
    sha256 "49940987dc62f9b95610a213027fff2f01b8c390f8608a120eefa10cca5e2887" => :el_capitan
    sha256 "7626710f8ff89e95a68312fb5c6a5e2498131b723ae5f771ba90c5ff933f8601" => :yosemite
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
    assert_match "1.17.3", shell_output("#{bin}/ykinfo -V 2>&1")
  end
end
