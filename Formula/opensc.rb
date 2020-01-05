class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.20.0/opensc-0.20.0.tar.gz"
  sha256 "bbf4b4f4a44463645c90a525e820a8059b2f742a53b7b944f941de3c97ba4863"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    rebuild 1
    sha256 "8e32ad0fc7f1a984272d9c187c2afa204fa6ad7a4835dd9945f5ee51241fffa8" => :catalina
    sha256 "7bb0f809f8cf73e9f5e35512224d0b87284464f225ea8e172908fc05d5ce6427" => :mojave
    sha256 "202a39a4e668d434e690fdf9853de8a0b278793b37ce99c1882ec9a03598368a" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<~EOS
    The OpenSSH PKCS11 smartcard integration will not work from High Sierra
    onwards. If you need this functionality, unlink this formula, then install
    the OpenSC cask.
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
