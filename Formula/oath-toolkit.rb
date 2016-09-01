class OathToolkit < Formula
  desc "Tools for one-time password authentication systems"
  homepage "http://www.nongnu.org/oath-toolkit/"
  url "https://download.savannah.gnu.org/releases/oath-toolkit/oath-toolkit-2.6.1.tar.gz"
  mirror "https://fossies.org/linux/privat/oath-toolkit-2.6.1.tar.gz"
  sha256 "9c57831907bc26eadcdf90ba1827d0bd962dd1f737362e817a1dd6d6ec036f79"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c3ffda5f36ff71da46bc4858d7d3e5feb1cb98bbc797ea076ed6909425f40620" => :el_capitan
    sha256 "0be1f426c8b8945c8eaef243521bb913d3db4b8d2ed64f3d27fec2e9c6ffc786" => :yosemite
    sha256 "e0e3c0a9d8f5d4aa98988af8edb6d3b7a96793c952a814126939fec9823c76c2" => :mavericks
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
