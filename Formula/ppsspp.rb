class Ppsspp < Formula
  desc "PlayStation Portable emulator"
  homepage "https://ppsspp.org/"
  url "https://github.com/hrydgard/ppsspp.git",
      :tag => "v1.3",
      :revision => "6d0d36bf914a3f5373627a362d65facdcfbbfe5f"
  head "https://github.com/hrydgard/ppsspp.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a9e8428ba84cbc664ea5dbde82fdb69566a38bd56b9908b87b7e1066ab437997" => :sierra
    sha256 "d18ed8da3ba0c39a614ab834c18a73a7315c8219d4783a5021f99d1c4b593534" => :el_capitan
    sha256 "5f4566de7fe6c2d32b9902db04e0aa7ee5da32d10592f86f556bc35a3bd8145c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "sdl2"
  depends_on "glew"
  depends_on "libzip"
  depends_on "snappy"
  depends_on "ffmpeg"

  def install
    args = std_cmake_args
    # Use brewed FFmpeg rather than precompiled binaries in the repo
    args << "-DUSE_SYSTEM_FFMPEG=ON"

    # fix missing include for zipconf.h
    ENV.append_to_cflags "-I#{Formula["libzip"].opt_prefix}/lib/libzip/include"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      prefix.install "PPSSPPSDL.app"
      bin.write_exec_script "#{prefix}/PPSSPPSDL.app/Contents/MacOS/PPSSPPSDL"
      mv "#{bin}/PPSSPPSDL", "#{bin}/ppsspp"
    end
  end
end
