class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.17.2.tar.bz2"
  sha256 "a341f8542f1f0b8c65241a17da13d073f18ec06658e1a1606a8ecc8bbc2b3314"
  head "http://repo.or.cz/openal-soft.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f947f310f7f89cc4ee0404c202aa06b0248a7e73ec91ea4b1c93ffb94be6b6e1" => :sierra
    sha256 "e5436e5970dafbc498ad6adea34caa764eb5db5de147ebf133fa3279d8a25c40" => :el_capitan
    sha256 "7e22b404371d06e26fdd15097531a18d5cdb27dff6d2e28b572108e4430ca1fc" => :yosemite
  end

  keg_only :provided_by_osx, "macOS provides OpenAL.framework."

  option :universal

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "portaudio" => :optional
  depends_on "pulseaudio" => :optional
  depends_on "fluid-synth" => :optional

  # clang 4.2's support for alignas is incomplete
  fails_with(:clang) { build 425 }

  def install
    ENV.universal_binary if build.universal?

    # Please don't reenable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = std_cmake_args
    args << "-DALSOFT_EXAMPLES=OFF"

    args << "-DALSOFT_BACKEND_PORTAUDIO=OFF" if build.without? "portaudio"
    args << "-DALSOFT_BACKEND_PULSEAUDIO=OFF" if build.without? "pulseaudio"
    args << "-DALSOFT_MIDI_FLUIDSYNTH=OFF" if build.without? "fluid-synth"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "AL/al.h"
      #include "AL/alc.h"
      int main() {
        ALCdevice *device;
        device = alcOpenDevice(0);
        alcCloseDevice(device);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopenal"
  end
end
