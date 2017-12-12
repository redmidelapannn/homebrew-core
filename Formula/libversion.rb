class Libversion < Formula
  desc "Advanced version string comparison library"
  homepage "https://github.com/repology/libversion"
  url "https://github.com/repology/libversion/archive/2.3.0.tar.gz"
  sha256 "f3cec57233c14173a45a801b97e9cf305c96656ac55aa8e15d91d4be29a4273d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3d6e6d29c2842124af568ed30754bcfb5e528393c4bce8f57839ca5a4eb6fb2" => :high_sierra
    sha256 "97938e285047efde16fa4bdd841a22455f8f398f28821652845344d9439fa888" => :sierra
    sha256 "cd3a8e2fb5d5cc60e5799a250926dc2d4d3cb1d11171445ef289321e42bf4c9b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "=", shell_output("#{bin}/version_compare 1.0 1.0.0")
  end
end
