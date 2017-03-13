class Taisei < Formula
  desc "Clone of Touhou Project shoot-em-up games"
  homepage "https://taisei-project.org/"
  url "https://github.com/laochailan/taisei/archive/v1.0a.tar.gz"
  version "1.0a"
  sha256 "1561c84c9fd8b9c7a91b864bdfc07fb811bb6da5c54cf32a2b6bd63de5f8f3ff"

  bottle do
    rebuild 1
    sha256 "b9e55e971cf6ba19153365e2530fe883149e7c126eb2ce0c1a6ba66d6c835c7a" => :sierra
    sha256 "b09715c96a10ca4a7ac4fe7ade953979f08795a8a223e879bc1f7f0ba3d31293" => :el_capitan
    sha256 "88b741f57534fb39179be59887010e3206ea4acde37c479cd7a7d03f70ca124c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "freealut"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "openal-soft" # OpenAL.framework gave ALUT state error
  depends_on "sdl"
  depends_on "sdl_ttf"

  # Fix newline at end of file to match master
  patch do
    url "https://github.com/laochailan/taisei/commit/779ff58684b1f229aedfcc03bfc6ac7aac17bf6a.diff"
    sha256 "eec218752bb025024112442ed9a254e352f71be966de98c3d9d4f1ed482059a0"
  end

  # Fix missing inline symbols
  patch do
    url "https://github.com/laochailan/taisei/commit/0f78b1a7eb05aa741541ca56559d7a3f381b57e2.diff"
    sha256 "a68859106a5426a4675b2072eb659fd4fb30c46a7c94f3af20a1a2e434685e1b"
  end

  # Support Mac OS X build
  patch do
    url "https://github.com/laochailan/taisei/commit/be8be15.patch"
    sha256 "29225ba39ce1aa093897ad4276da35a972b320e3ad01ffa14ab7b32e3acb4626"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    (share/"applications").rmtree
    (share/"icons").rmtree
  end

  def caveats
    "Sound may not work."
  end
end
