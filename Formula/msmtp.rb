class Msmtp < Formula
  desc "SMTP client that can be used as an SMTP plugin for Mutt"
  homepage "https://msmtp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/msmtp/msmtp/1.6.6/msmtp-1.6.6.tar.xz"
  sha256 "da15db1f62bd0201fce5310adb89c86188be91cd745b7cb3b62b81a501e7fb5e"

  bottle do
    rebuild 1
    sha256 "0b70918c0e408c2cdcf1080a97fb3e333c486fc7f06062a51cfdd83d7057a8d3" => :sierra
    sha256 "de6e7613f7b6b22233420ab45dcdb1045680382133fd87cdfa2d23ec8590bf7f" => :el_capitan
  end

  option "with-gsasl", "Use GNU SASL authentication library"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "gsasl" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --with-macosx-keyring
      --prefix=#{prefix}
      --with-tls=openssl
    ]

    args << "--with-libsasl" if build.with? "gsasl"

    system "./configure", *args
    system "make", "install"
    (pkgshare/"scripts").install "scripts/msmtpq"
  end

  test do
    system bin/"msmtp", "--help"
  end
end
