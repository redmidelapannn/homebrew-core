class BoostBuildAT168 < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.68.0.tar.gz"
  sha256 "0b8612f45c43da57f370234f52018d4a6a22e11e0fcd0dff4050a1650d82e294"

  bottle do
    cellar :any_skip_relocation
    sha256 "884b3aad0836edf093a5396c4e92a3e4d3d7a519b05946692ee5490bc2c2309b" => :mojave
    sha256 "09a123c4d54f1025bf3742fcb32522cbe2784b09a5b3c6275db5833edeb434ae" => :high_sierra
    sha256 "9734f2f06c002865ddc519ba08e3f5941e7b7318260196f25e36473a122a0de9" => :sierra
  end

  keg_only :versioned_formula

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end

  test do
    (testpath/"hello.cpp").write <<~EOS
      #include <iostream>
      int main (void) { std::cout << "Hello world"; }
    EOS
    (testpath/"Jamroot.jam").write("exe hello : hello.cpp ;")

    system bin/"b2", "release"
    out = Dir["bin/darwin-*/release/hello"]
    assert out.length == 1
    assert_predicate testpath/out[0], :exist?
    assert_equal "Hello world", shell_output(out[0])
  end
end
