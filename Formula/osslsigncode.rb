class Osslsigncode < Formula
  desc "OpenSSL based Authenticode signing for PE/MSI/Java CAB files"
  homepage "https://github.com/mtrojnar/osslsigncode"
  url "https://github.com/mtrojnar/osslsigncode/archive/2.0.tar.gz"
  sha256 "5a60e0a4b3e0b4d655317b2f12a810211c50242138322b16e7e01c6fbb89d92f"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "db08b5e426b19abe56a89ce6e46041379690be3d304c24a8891f73b57d4824d4" => :catalina
    sha256 "c63fa3c4c12b8504b33db4ca92daf31872277d87905b0c3f74a594afb64ae996" => :mojave
    sha256 "262090d8eaffc4bb84e414582c1d66b7ee21ac39b92c6cf2a83febbc8f205d16" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libgsf"
  depends_on "openssl@1.1"

  uses_from_macos "curl"

  def install
    system "./autogen.sh"
    system "./configure", "--with-gsf", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Requires Windows PE executable as input, so we're just showing the version
    assert_match "osslsigncode", shell_output("#{bin}/osslsigncode --version", 255)
  end
end
