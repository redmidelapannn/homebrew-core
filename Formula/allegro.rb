class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.2.0/allegro-5.2.2.tar.gz"
  sha256 "e285b9e12a7b33488c0e7e139326903b9df10e8fa9adbfcfe2e1105b69ce94fc"

  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  bottle do
    cellar :any
    rebuild 1
    sha256 "8aa9a8bbfa6d4989ba412ad64ad8a708a22019e85289003e6fed4c5fc628477c" => :sierra
    sha256 "7d1ca0056f72b30567b75639f04238c8380ddd1a94d846bfb5d6905598e74e59" => :el_capitan
    sha256 "41a14b5c1041e104ab33e2f4e8fa83361a9a744f4b688a2caaca5f785e824173" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "opusfile"
  depends_on "physfs"
  depends_on "theora"
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
    (testpath/"allegro_test.cpp").write <<-EOS
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
