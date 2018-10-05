class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-1.6.2.tar.gz"
  sha256 "ea61bcd5c75471ed21903967d0121fb090aa4d325ec279a24633e3235fdf231b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0ff645f3795be6475e06b7fdf122e26781b3a5a7aff84405232e202ed8480c90" => :mojave
    sha256 "960659fae0aaf01b447840cc9851c04b6671b449590b3f193cc5f724bd3e2160" => :high_sierra
    sha256 "f7f86af38df615b792fde162859fcef9860b9a6f01af1c9d48d533140f21b1f6" => :sierra
  end

  depends_on "check" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
