class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20190203.tar.gz"
  sha256 "e526f1659ae321f45b997c0245acecbf9c4cf2122b025ab8db1090f1b9804f5e"
  revision 2
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "c6b39b48dc0f06e4d921c92c6ec69125aa89c6f84d2f839ca6bf73f8cea6d1d8" => :catalina
    sha256 "14d7f746474ee3391e3b38adf7e66f94fe67b77627987f6ed5ca2677f3596816" => :mojave
    sha256 "baa67a17905ee95061fbda4112545e15e0a14bbaab94b67fcc0707e4dd015698" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    ENV.cxx11

    # Set PROJECT_VERSION to be the date of release, not the build date
    inreplace "CMakeLists.txt", "string(TIMESTAMP PROJECT_VERSION \"\%Y\%m\%d\")", "set(PROJECT_VERSION #{version})"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "#{name} #{version}", shell_output("#{bin}/pioneer -v 2>&1").chomp
    assert_match "modelcompiler #{version}", shell_output("#{bin}/modelcompiler -v 2>&1").chomp
  end
end
