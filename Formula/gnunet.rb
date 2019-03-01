class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.11.0.tar.gz"
  sha256 "b7477a3c3b0d5e8a013685dc208cfb4ccee4145f8668faa8eb5b382af36c7e9a"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libmpc"
  depends_on "libunistring"
  depends_on "unbound"

  def install
    args = %W[
      --disable-documentation
      --prefix=#{prefix}
    ]

    system "./configure", *args
    chmod "+x", "src/util/gnunet-qr.py"
    system "make", "install"
  end

  test do
    system bin/"gnunet-arm", "--start"
    system bin/"gnunet-arm", "--end"
  end
end
