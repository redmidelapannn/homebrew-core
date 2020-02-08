class Kpack < Formula
  desc "Manipulates KnightOS packages on POSIX systems"
  homepage "https://github.com/KnightOS/kpack"
  url "https://github.com/KnightOS/kpack/archive/1.0.12.tar.gz"
  sha256 "f63e53a390ef9300caaa9042ec030154d4825ebaa360ffb96720df11a591af4f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8276457c1147c185436b1f1465432a33a55f51ec76abbb180d6482b06b35529" => :catalina
    sha256 "289d820f0dc85c59ba2cfa61ed611b0b7f3cb4116c249d4c2350f585015b4f99" => :mojave
    sha256 "8b08541701846ff97f5dd2d13d890e724c32a346d0526e3ff4eac19488684721" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "git", "clone", "-b", "0.5.1", "https://github.com/KnightOS/castle"
    system bin/"kpack", testpath/"castle.pkg", "castle", "-c", "castle/package.config"
    mkdir testpath/"castle2"
    system bin/"kpack", "-e", testpath/"castle.pkg", testpath/"castle2"
    system bin/"kpack", testpath/"castle2.pkg", testpath/"castle2", "-c", testpath/"castle2/package.config"
    assert_equal (testpath/"castle.pkg").sha256, (testpath/"castle2.pkg").sha256
  end
end
