class Libgroove < Formula
  desc "Streaming audio processing library"
  homepage "https://github.com/andrewrk/libgroove"
  url "https://github.com/andrewrk/libgroove/archive/4.3.0.tar.gz"
  sha256 "76f68896f078a9613d420339ef887ca8293884ad2cd0fbc031d89a6af2993636"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "c0ebdda455e4dd110a8a4fbea44c2c16af6c8cadafe75eae94e1da168ffc63c4" => :sierra
    sha256 "015879b7e5134eddae3906b880a7e2b79f815f02dd3b2033e90851b78fad4d21" => :el_capitan
    sha256 "1ab4d5a774455e2bdb5289ff98d05bb9f9e71bb389978fa5c47563f204fda878" => :yosemite
  end

  depends_on :macos => :mavericks
  depends_on "cmake" => :build
  depends_on "ffmpeg" => "with-libvorbis"
  depends_on "chromaprint"
  depends_on "libebur128"
  depends_on "sdl2"

  def install
    # "typedef redefinition with different types ('int' vs 'enum clockid_t')"
    if DevelopmentTools.clang_build_version >= 800
      inreplace "grooveplayer/osx_time_shim.h", "typedef int clockid_t;", ""
    end

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <groove/groove.h>
      int main() {
        groove_init();
        groove_version();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgroove", "-o", "test"
    system "./test"
  end
end
