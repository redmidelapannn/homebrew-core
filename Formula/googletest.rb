class Googletest < Formula
  desc "Google's C++ test framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/release-1.8.0.tar.gz"
  sha256 "58a6f4277ca2bc8565222b3bbd58a177609e9c488e8a72649359ba51450db7d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e3a223a9f308475b43d113d887cbb274696dda805cb3fe10f5dbe8170b97006" => :sierra
    sha256 "326bdd109efde53c93b2a0a4b72a6e0533be46320f35697d08462773a53dd2c3" => :el_capitan
    sha256 "c446591173d651902662a0f6cd4d99206983c837775542f7c64c5f8c73ef2063" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    args = [
      "-DCMAKE_INSTALL_PREFIX=#{prefix}",
    ]

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<-EOS.undent
      #include <gtest/gtest.h>

      int main()
      {
        EXPECT_TRUE(1 > 0);
      }
    EOS

    system ENV.cxx, "test.cc", "-lgtest", "-o", "test"
    system "./test"
  end
end
