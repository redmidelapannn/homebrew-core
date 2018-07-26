class Supertux < Formula
  desc "Classic 2D jump'n run sidescroller game"
  homepage "https://supertux.org/"
  url "https://github.com/SuperTux/supertux/releases/download/v0.5.1/SuperTux-v0.5.1-Source.tar.gz"
  sha256 "c9dc3b42991ce5c5d0d0cb94e44c4ec2373ad09029940f0e92331e7e9ada0ac5"
  revision 3
  head "https://github.com/SuperTux/supertux.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "c0132295718b5146b3a726cd38609fa0bef5341e6c443fc60a521b2f2b90f5f8" => :high_sierra
    sha256 "9aa7ee85b7e36b645aa0c01549e5c579b5de54769d99fcab7c5e0c1ac93d5611" => :sierra
    sha256 "37bbd4724023935c86b2b2bfef4395a12405f6defbe22862856d7308a7180da7" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "glew"

  # Fix symlink passing to physfs
  # https://github.com/SuperTux/supertux/issues/614
  patch do
    url "https://github.com/SuperTux/supertux/commit/47a353e2981161e2da12492822fe88d797af2fec.diff?full_index=1"
    sha256 "2b12aeead4f425a0626051e246a9f6d527669624803d53d6d0b5758e51099059"
  end

  # Fix compilation issue with Xcode 9
  # https://github.com/SuperTux/supertux/issues/762
  # using Squirrel's patch
  # https://github.com/albertodemichelis/squirrel/commit/a3a78eec
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/834e41a/supertux/squirrel_xcode9.patch"
    sha256 "1830dcb88f635f611aa3236abdaee75b53293df407ebc8214f31635a75876831"
  end

  needs :cxx11

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DINSTALL_SUBDIR_BIN=bin"
    args << "-DINSTALL_SUBDIR_SHARE=share/supertux"
    # Without the following option, Cmake intend to use the library of MONO framework.
    args << "-DPNG_PNG_INCLUDE_DIR=#{Formula["libpng"].opt_include}"
    system "cmake", ".", *args
    system "make", "install"

    # Remove unnecessary files
    (share/"appdata").rmtree
    (share/"applications").rmtree
    (share/"pixmaps").rmtree
    (prefix/"MacOS").rmtree
  end

  test do
    assert_equal "supertux2 v#{version}", shell_output("#{bin}/supertux2 --version").chomp
  end
end
