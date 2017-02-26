class PamYubico < Formula
  desc "Yubico pluggable authentication module"
  homepage "https://developers.yubico.com/yubico-pam/"
  url "https://developers.yubico.com/yubico-pam/Releases/pam_yubico-2.23.tar.gz"
  sha256 "bc7193ed10c8fb7a2878088af859a24a7e6a456e1728a914eb5ed47cdff0ecb8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "27bf40e80c368615e71963d8b7df8f0e01d85180c8fc9ea02634dde18146dc0c" => :sierra
    sha256 "95c308d0bafe19e39227c60ba7efa5d1f3184cbdb7a429e142a915e3d37ba68e" => :el_capitan
    sha256 "11e787e2d141057f3d225b4054c9eadc24bd6c564ab9319da27345d740f1fe97" => :yosemite
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
