class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.24.tar.gz"
  sha256 "0326ff676e2b32ed1dda7fb5f1358a22d629d71caad8f8db52138bbf3e95e82d"
  revision 1

  bottle do
    cellar :any
    sha256 "f6c1d70f8007854f00cbfd25476e52aeda17d196fa126a51665ef0d5381fe0c1" => :high_sierra
    sha256 "22b0c836a347a17d7176a2126f7d1791c2041547bc86431e448024e995b174e5" => :sierra
    sha256 "5a074fdb4a16694715bee9afd1427acc696cfe1ffc717254270f7f6b59e59b9f" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libyubikey"
  depends_on "ykclient"
  depends_on "ykpers"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--prefix=#{prefix}",
                          "--with-libyubikey-prefix=#{Formula["libyubikey"].opt_prefix}",
                          "--with-libykclient-prefix=#{Formula["ykclient"].opt_prefix}"
    system "make", "install"
  end

  test do
    # Not much more to test without an actual yubikey device.
    system "#{bin}/ykpamcfg", "-V"
  end
end
