class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=avro/avro-1.8.2/cpp/avro-cpp-1.8.2.tar.gz"
  sha256 "5328b913882ee5339112fa0178756789f164c9c5162e1c83437a20ee162a3aab"

  bottle do
    cellar :any
    rebuild 1
    sha256 "17f4a2850d618e9a6ef52e5c44f2fd70837a754e961426d0fb41c17bc99db69c" => :mojave
    sha256 "05e976f81985a7d33a5f6c54b4c864de5c4facc2e2b8ccfa8267d7be6fe505e8" => :high_sierra
    sha256 "b084a8c56e815421c224e32b7d9e2fccc52d1343e54f95dddce8fe3d1873d1a8" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}/avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
