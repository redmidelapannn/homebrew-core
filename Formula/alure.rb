class Alure < Formula
  desc "Manage common tasks with OpenAL applications"
  homepage "http://kcat.strangesoft.net/alure.html"
  url "http://kcat.strangesoft.net/alure-releases/alure-1.2.tar.bz2"
  sha256 "465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b29ee5779c17c5b59241581b2ca19db4c19cd3caff77c7b3a0721d044446f65d" => :sierra
    sha256 "5626be29f8194ffadd804d3d5a19a616a818722690e331578a616d8155bd6495" => :el_capitan
    sha256 "aa2fb5d15654932436bf2e7089dc38af73f7df72f84fcf4c745de3ce62871911" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "libogg" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libvorbis" => :optional
  depends_on "mpg123" => :optional

  def install
    # fix a broken include flags line, which fixes a build error.
    # Not reported upstream.
    # https://github.com/Homebrew/legacy-homebrew/pull/6368
    if build.with? "libvorbis"
      inreplace "CMakeLists.txt", "${VORBISFILE_CFLAGS}",
        Utils.popen_read("pkg-config --cflags vorbisfile").chomp
    end

    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"alureplay", test_fixtures("test.wav")
  end
end
