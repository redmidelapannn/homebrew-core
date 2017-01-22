class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "http://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.1.tar.gz"
  sha256 "9c57831907bc26eadcdf90ba1827d0bd962dd1f737362e817a1dd6d6ec036f79"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b5531a895b4958303cca02009fcf60a641a343efee9fdc75a772c836315435a9" => :sierra
    sha256 "e69acd5ca1cdfcc862bd8105d6e97f080d3d5c1adbdb8aec579ab6d9087f11b9" => :el_capitan
    sha256 "8c90c0ce5e3ef2f3dd9a8b370ae3ebee8b446e6442e2b8c7886f14b6cd5b3dfd" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libxmlsec1"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "328482", shell_output("oathtool 00").chomp
  end
end
