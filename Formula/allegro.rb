class Allegro < Formula
  desc "C/C++ multimedia library for cross-platform game development"
  homepage "http://liballeg.org/"
  url "http://download.gna.org/allegro/allegro/5.2.0/allegro-5.2.0.tar.gz"
  sha256 "af5a69cd423d05189e92952633f9c0dd0ff3a061d91fbce62fb32c4bd87f9fd7"
  head "https://github.com/liballeg/allegro5.git", :branch => "master"

  bottle do
    cellar :any
    revision 1
    sha256 "3131dd2c1ec97f3991fc2e6b8a274e0cb8fb589700fe55f005ff269dd859350e" => :el_capitan
    sha256 "fa559e41fc0c447f8a18e416220f8e6ca1dc915b03ecf1cabb509242831d74c6" => :yosemite
    sha256 "b3c40ad21d7049c7562f3112fa37acd761fa0074003ee585816fecc2483aa6c9" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "libvorbis" => :recommended
  depends_on "freetype" => :recommended
  depends_on "flac" => :recommended
  depends_on "physfs" => :recommended
  depends_on "libogg" => :recommended
  depends_on "theora" => :recommended
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
