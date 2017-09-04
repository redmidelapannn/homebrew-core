class BoostBuild < Formula
  desc "C++ build system"
  homepage "https://www.boost.org/build/"
  url "https://github.com/boostorg/build/archive/2016.03.tar.gz"
  sha256 "1e79253a6ce4cadb08ac1c05feaef241cbf789b65362ba8973e37c1d25a2fbe9"

  head "https://github.com/boostorg/build.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "699da959fe11f9a6fe7950b53eab0cea398ff0cca274916b8329ae7c7ccda98f" => :sierra
    sha256 "2a580efd0ff88b49fa4a2b6c90580adb2e9bbf6da67efb42c11af624d071a54a" => :el_capitan
    sha256 "09094e391f50adfa3d0ae7a0ed20fdd8f287f31c11e09d275a1953ade62ca17d" => :yosemite
  end

  conflicts_with "b2-tools", :because => "both install `b2` binaries"

  def install
    system "./bootstrap.sh"
    system "./b2", "--prefix=#{prefix}", "install"
  end

  test do
    (testpath/"hello.cpp").write <<-EOF.undent
      #include <iostream>
      int main (void) { std::cout << "Hello world"; }
    EOF
    (testpath/"Jamroot.jam").write("exe hello : hello.cpp ;")

    system bin/"b2", "release"
    out = Dir["bin/darwin-*/release/hello"]
    assert (out.length == 1) && File.exist?(out[0])
    assert_equal "Hello world", shell_output(out[0])
  end
end
