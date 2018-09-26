class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/boost-1.68.0.tar.gz"
  sha256 "0b8612f45c43da57f370234f52018d4a6a22e11e0fcd0dff4050a1650d82e294"
  version_scheme 1
  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b7e9bd4e6e1114a0f1b8c7e56af736b241036925e5155eab64b01673ccb66bf" => :mojave
    sha256 "04f61e6b2e425c2ddce01903af1758b7571fa96025ce9429f0e13942b1e4108f" => :high_sierra
    sha256 "4b402bc5035a1565b04d07ee612c88c4c9899d53f285a260af92449f8f6fcd95" => :sierra
  end

  conflicts_with "b2-tools", :because => "both install `b2` binaries"

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
