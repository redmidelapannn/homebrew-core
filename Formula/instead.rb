class Instead < Formula
  desc "Interpreter of simple text adventures"
  homepage "https://instead.syscall.ru/"
  url "https://github.com/instead-hub/instead/archive/3.2.0.tar.gz"
  sha256 "ed25f8efcebe1b33401704ff1c0b9151ca08e799a2f840b10ebfd2f0a0bf3f7a"
  head "https://github.com/instead-hub/instead.git"

  bottle do
    sha256 "58f74d455faac9ad3fef46cb85e76ab45edd9f529026f1f858cf868f3ca12d4f" => :high_sierra
    sha256 "25842f422b5d02f700af456739a3161891ba61f20a09d66e0b2f07379f223068" => :sierra
    sha256 "b3d1a9305705d80a7a5bc0f2033b20e7bee8e4f327a814a930c5b500cc79572d" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "lua"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "sdl2_ttf"

  def install
    ENV["LDFLAGS"] = "-framework AppKit"

    mkdir "build" do
      system "cmake", "..", "-DWITH_GTK2=OFF", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match /INSTEAD #{version} /, shell_output("#{bin}/instead -h 2>&1")
  end
end
