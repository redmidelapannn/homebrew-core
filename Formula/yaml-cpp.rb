class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/release-0.5.3.tar.gz"
  sha256 "ac50a27a201d16dc69a881b80ad39a7be66c4d755eda1f76c3a68781b922af8f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "606f81147ea40a54bdf215fe53a3c4abb18c73df2e0875bb0b7dadfc193954bd" => :sierra
    sha256 "6dc46a676b842dc5ae1d50963bc141562145e0832b770ff634d7370900d25c69" => :el_capitan
    sha256 "d06008984c13370990ab28b1532361be14253e215442bdf4e4c02204e223cbc4" => :yosemite
  end

  option :cxx11
  option "with-static-lib", "Build a static library"

  depends_on "cmake" => :build

  if build.cxx11? && MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11 if build.cxx11?
    args = std_cmake_args
    if build.with? "static-lib"
      args << "-DBUILD_SHARED_LIBS=OFF"
    else
      args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <yaml-cpp/yaml.h>
      int main() {
        YAML::Node node  = YAML::Load("[0, 0, 0]");
        node[0] = 1;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lyaml-cpp", "-o", "test"
    system "./test"
  end
end
