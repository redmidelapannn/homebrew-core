class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.9.2/cpp/avro-cpp-1.9.2.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.9.2/cpp/avro-cpp-1.9.2.tar.gz"
  sha256 "bd50f380ed4f77231721ee2347dd0ca3991f6fec5254acdf7e5f105253deba6b"

  bottle do
    cellar :any
    rebuild 1
    sha256 "22ecca5351027b11407bc7b389b90ce4f269a04c5e7cfbd0725283f0355043d5" => :catalina
    sha256 "ceb402c1b60b5ffe21d833699c6e10d936f82aa454132194832c69a6f742418b" => :mojave
    sha256 "ab52f394a56bafbaea678ef985a44e4032d3fd8b546f0e3418b351a630db277b" => :high_sierra
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
