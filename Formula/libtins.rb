class Libtins < Formula
  desc "C++ network packet sniffing and crafting library"
  homepage "https://libtins.github.io/"
  url "https://github.com/mfontanini/libtins/archive/v4.0.tar.gz"
  sha256 "2a758d1bed51760bbd57fcaa00610534e0cc3a6d55d91983724e5f46739d66b8"
  revision 1
  head "https://github.com/mfontanini/libtins.git"

  bottle do
    cellar :any
    sha256 "245b61e18860ad3e176476febd0e586ff667ff4410e7d3b4527a6575e2411b89" => :high_sierra
    sha256 "a11d7c3582d16ff5cb4d4d8179b2cb73a256b40d471c72b74e66de91288506c8" => :sierra
    sha256 "0aa68e260eaff5cfac891086bced87633af9601d5370438ac1aa4945c7cecb70" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    doc.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <tins/tins.h>
      int main() {
        Tins::Sniffer sniffer("en0");
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-ltins", "-o", "test"
  end
end
