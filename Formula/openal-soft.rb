class OpenalSoft < Formula
  desc "Implementation of the OpenAL 3D audio API"
  homepage "http://kcat.strangesoft.net/openal.html"
  url "http://kcat.strangesoft.net/openal-releases/openal-soft-1.18.2.tar.bz2"
  sha256 "9f8ac1e27fba15a59758a13f0c7f6540a0605b6c3a691def9d420570506d7e82"
  head "http://repo.or.cz/openal-soft.git"

  bottle do
    rebuild 1
    sha256 "7b062973bcc44b0fbe920f4a67a51cd3d485c6ac17ba1e0b7dd7f410b33e883d" => :high_sierra
    sha256 "6d12b56e0c3bc257e1c54444573ec5b17b4ee9615ecaeeea40f1ebded898f46e" => :sierra
    sha256 "b02d89d7407e4fd3346dea6349e034ccce4ee377e1589292d6bd302989aafe98" => :el_capitan
  end

  keg_only :provided_by_osx, "macOS provides OpenAL.framework"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "portaudio" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "jack" => :optional

  # clang 4.2's support for alignas is incomplete
  fails_with(:clang) { build 425 }

  def install
    #  See: https://github.com/kcat/openal-soft/issues/153
    ENV.append "LDFLAGS", "-Wl,-rpath,#{opt_lib}"

    # Please don't reenable example building. See:
    # https://github.com/Homebrew/homebrew/issues/38274
    args = std_cmake_args
    args << "-DALSOFT_EXAMPLES=OFF" <<"-DALSOFT_BACKEND_PULSEAUDIO=OFF"

    args << "-DALSOFT_BACKEND_PORTAUDIO=OFF" if build.without? "portaudio"
    args << "-DALSOFT_MIDI_FLUIDSYNTH=OFF" if build.without? "fluid-synth"
    args << "-DALSOFT_BACKEND_JACK=OFF" if build.without? "jack"

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
