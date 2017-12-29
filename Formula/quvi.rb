class Quvi < Formula
  desc "Parse video download URLs"
  homepage "https://quvi.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/quvi/0.9/quvi/quvi-0.9.5.tar.xz"
  sha256 "cb3918aad990b9bc49828a5071159646247199a63de0dd4c706adc5c8cd0a2c0"

  bottle do
    sha256 "88561c10054820049c22455e74abb6aef21552b48a1a2f6c825e4a4daf73a6d6" => :high_sierra
    sha256 "5984f0ee650ecf20dbb2bbbfb43adb6a80576a792e74a01c417860bf4aab7c59" => :sierra
    sha256 "d2ee74e121cbf711ad660d1b71e52361dfaca0ba62cfa84b61ce5d69f12eb962" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libquvi"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/quvi", "--version"
  end
end
