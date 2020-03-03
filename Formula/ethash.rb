class Ethash < Formula
  desc "C/C++ implementation of Ethereum Proof of Work algorithm"
  homepage "https://github.com/chfast/ethash"
  url "https://github.com/chfast/ethash/archive/v0.5.1.tar.gz"
  sha256 "69894698dcdbdaf7c601427e47de7fea12449a73617ab6deac1601167232a1b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d6372b3d3cbb912515d4a79d57146a33ac9141fd9c3507e752ec7168597744c" => :catalina
    sha256 "2cc5debc8bb212c469ad209fce21310d90dbaec4b4de1981ecf64f951d1239d1" => :mojave
    sha256 "273197895d585fcdd3eb79b7837b86d680b12c012932f77a1bcef2f9bdbe5f9a" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DHUNTER_ENABLED=OFF", "-DETHASH_BUILD_TESTS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS
      #include <ethash/ethash.hpp>
      #include <string>
      #include <iostream>

      std::string to_hex(const ethash::hash256& h)
      {
          auto hex_chars = "0123456789abcdef";
          std::string str;
          str.reserve(sizeof(h) * 2);
          for (auto b : h.bytes)
          {
              str.push_back(hex_chars[uint8_t(b) >> 4]);
              str.push_back(hex_chars[uint8_t(b) & 0xf]);
          }
          return str;
      }

      int main()
      {
        std::cout << to_hex(ethash::calculate_epoch_seed(29998));
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-lethash", "-lkeccak", "-o", "test", "test.cpp"
    assert_match "1222b1faed7f93098f8ae498621fb3479805a664b70186063861c46596c66164", shell_output("./test")
  end
end
