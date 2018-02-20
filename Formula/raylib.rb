class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "http://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/1.9.1-dev.tar.gz"
  version "1.9.1-dev"
  sha256 "892357fb44d340eb7449c23c425d660d98b34b91434400e7610514ef02698600"
  head "https://github.com/raysan5/raylib.git", :branch => "master"

  bottle do
    cellar :any
    rebuild 1
    sha256 "73bcd5d6a0dd2a50b73968d70159a57e79d489031b6477d68407c7be27d612d6" => :high_sierra
    sha256 "f5f4d671243658558c42dc687c963a45ed5b359412d568ec49f7df2be0d5011c" => :sierra
    sha256 "ce5858cd29c680c60946acbe9613171644af3020cfa7a5896a74fb6864f6eaa1" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DSTATIC_RAYLIB=ON",
                         "-DSHARED_RAYLIB=ON",
                         "-DMACOS_FATLIB=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_GAMES=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <raylib.h>
      int main(void)
      {
          int num = GetRandomValue(42, 1337);
          return 42 <= num && num <= 1337 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lraylib", "-o", "test"
    system "./test"
  end
end
