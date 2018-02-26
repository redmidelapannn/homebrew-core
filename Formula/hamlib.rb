class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "https://hamlib.sourceforge.io/"
  url "https://src.fedoraproject.org/repo/pkgs/hamlib/hamlib-1.2.15.3.tar.gz/3cad8987e995a00e5e9d360e2be0eb43/hamlib-1.2.15.3.tar.gz"
  sha256 "a2ca4549e4fd99d6e5600e354ebcb57502611aa63c6921c1b8a825289833f75e"

  bottle do
    rebuild 2
    sha256 "435aa01d0c0d8b0eb42e9450c8f27cd80148d98259bd29d4802a43f5ea9aa29d" => :high_sierra
    sha256 "3a13ad6021ca10b54510f69491f6b1241c3e46ed5e0a2044579ab24c75519773" => :sierra
    sha256 "3afbab9ea6146217b4f9b81821064e5a98dd3993b1f96b5ce6297dac36bc9b63" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
