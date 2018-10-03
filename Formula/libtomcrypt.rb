class Libtomcrypt < Formula
  desc "Comprehensive, modular and portable cryptographic toolkit"
  homepage "https://www.libtom.net/"
  url "https://github.com/libtom/libtomcrypt/archive/v1.18.2.tar.gz"
  sha256 "d870fad1e31cb787c85161a8894abb9d7283c2a654a9d3d4c6d45a1eba59952c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "da68016b386de806055ed23ee44f636a65a02669cbc8229efe125e9d6dd0cdbc" => :mojave
    sha256 "f899b6425f601c02bd08204380ab80e44abef0747e35d13487e5a6730d2e0805" => :high_sierra
    sha256 "ca13145ad64fb942d72d30db5389260f5752918ba92ecfc79aa626b9e6ed9723" => :sierra
  end

  depends_on "libtommath"

  def install
    system "make", "test", "CFLAGS+=-DLTM_DESC"
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test"
    (pkgshare/"tests").install "tests/test.key"
  end

  test do
    cp_r Dir[pkgshare/"*"], testpath
    system "./test"
  end
end
