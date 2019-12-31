class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://files.dyne.org/frei0r/releases/frei0r-plugins-1.7.0.tar.gz"
  sha256 "1b1ff8f0f9bc23eed724e94e9a7c1d8f0244bfe33424bb4fe68e6460c088523a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "76bb5fc609bdfb65e86c3f9ee8da17332f48b9f03dc19f3193e4f6cb933f9981" => :catalina
    sha256 "06fa827c88701c25335296ce667c35a3ba2f2339b40c32c4cf6cd06093ae5931" => :mojave
    sha256 "deb64476a0562e93e2cc4de4299cfacb8803cde24e61328d65e2ff4f08e90349" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""
    cmake_args = std_cmake_args + %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
