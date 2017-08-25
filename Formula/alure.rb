class Alure < Formula
  desc "Manage common tasks with OpenAL applications"
  homepage "http://kcat.strangesoft.net/alure.html"
  url "http://kcat.strangesoft.net/alure-releases/alure-1.2.tar.bz2"
  sha256 "465e6adae68927be3a023903764662d64404e40c4c152d160e3a8838b1d70f71"

  bottle do
    cellar :any
    rebuild 1
    sha256 "25d7fbead0d9b272e740596297f2cad72ffb14ae7bba7dc8fba20a4834ccc441" => :sierra
    sha256 "9bf1fc90c78d26276e42b276f28e34de42d9e7d43474d96063ec6fbaf3199084" => :el_capitan
    sha256 "1082f27e2806bf137f538881adc6892f43432e0425ac8c407b44f398bba75453" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "flac" => :optional
  depends_on "fluid-synth" => :optional
  depends_on "libogg" => :optional
  depends_on "libsndfile" => :optional
  depends_on "libvorbis" => :optional
  depends_on "mpg123" => :optional

  # Fix missing unistd include
  # Reported by email to author on 2017-08-25
  if MacOS.version >= :high_sierra
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/eed63e836e/alure/unistd.patch"
      sha256 "7852a7a365f518b12a1afd763a6a80ece88ac7aeea3c9023aa6c1fe46ac5a1ae"
    end
  end

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
