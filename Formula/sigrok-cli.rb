class SigrokCli < Formula
  desc "Command-line frontend for sigrok"
  homepage "https://sigrok.org/wiki/Sigrok-cli"
  url "https://sigrok.org/download/source/sigrok-cli/sigrok-cli-0.7.0.tar.gz"
  sha256 "5669d968c2de3dfc6adfda76e83789b6ba76368407c832438cef5e7099a65e1c"

  bottle do
    cellar :any
    sha256 "1b44d38b5dd70b7e7139b409018224e9752d5c027768e8d31fdf0620e95d1c59" => :catalina
    sha256 "acc368a555694525c20a1cffdecd3448dff282d23ac41e2c80b158d7cf91b6bc" => :mojave
    sha256 "077e1492cbfaf42e37976131375751683a4fa6e8632b0b2e6eb7052aae1e3873" => :high_sierra
  end

  depends_on "glib" => :build
  depends_on "make" => :build
  depends_on "pkg-config" => :build
  depends_on "libsigrok"
  depends_on "libsigrokdecode"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/sigrok-cli", "-L"
  end
end
