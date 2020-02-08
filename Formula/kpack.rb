class Kpack < Formula
  desc "Manipulates KnightOS packages on POSIX systems"
  homepage "https://github.com/KnightOS/kpack"
  url "https://github.com/KnightOS/kpack/archive/1.0.12.tar.gz"
  sha256 "f63e53a390ef9300caaa9042ec030154d4825ebaa360ffb96720df11a591af4f"

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
