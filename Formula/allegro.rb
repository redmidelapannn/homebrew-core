class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.4.0/allegro-5.2.4.0.tar.gz"
  sha256 "346163d456c5281c3b70271ecf525e1d7c754172aef4bab15803e012b12f2af1"

  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7f1ba7be821dfe04f222af910f01ac0ed5dc3f0be076ffe4cef0cee1eb937067" => :high_sierra
    sha256 "7bbe0d5dae7fd66d5101ca5aaf22f3a52f65fdde02542753032761b58ee1d870" => :sierra
    sha256 "0c36ea4cf06328f20d90f49d346866dfa31cf9c359eb7817240f00fffc1b31e0" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
  depends_on "webp"
  depends_on "dumb" => :optional

  def install
    args = std_cmake_args
    args << "-DWANT_DOCS=OFF"
    args << "-DWANT_MODAUDIO=1" if build.with?("dumb")
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"allegro_test.cpp").write <<~EOS
      #include <assert.h>
      #include <allegro5/allegro5.h>

      int main(int n, char** c) {
        if (!al_init()) {
          return 1;
        }
        return 0;
      }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lallegro", "-lallegro_main", "-o", "allegro_test", "allegro_test.cpp"
    system "./allegro_test"
  end
end
