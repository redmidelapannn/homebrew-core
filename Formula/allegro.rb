class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "https://liballeg.org/"
  url "https://github.com/liballeg/allegro5/releases/download/5.2.4.0/allegro-5.2.4.0.tar.gz"
  sha256 "346163d456c5281c3b70271ecf525e1d7c754172aef4bab15803e012b12f2af1"
  head "https://github.com/liballeg/allegro5.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dced7f08bf0605fe5d0a86f2b82200f30295b63222f34c1ce08d80c7369dfb7a" => :mojave
    sha256 "ccd031d537a1d092743b1e62b99d0d894c3d6d5ea91a59f05ac57f1c79661207" => :high_sierra
    sha256 "c26ed5dbdfe542a91d7adb13ab7309d23fb8645b2d1fc55b42f37013de27a4ce" => :sierra
    sha256 "529fff9cbdc433337aeb7bb6a9b2368e3086136c516ceac69b0deb93dba23fcf" => :el_capitan
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
    args << "-DWANT_MODAUDIO=1" if build.with? "dumb"
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

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-lallegro", "-lallegro_main",
                    "-o", "allegro_test", "allegro_test.cpp"
    system "./allegro_test"
  end
end
