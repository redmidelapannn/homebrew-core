class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://mapcrafter.org"
  url "https://github.com/mapcrafter/mapcrafter/archive/v.2.3.1.tar.gz"
  sha256 "b88e53ccffc00f83717f2e686dbed047b95f011187af2b7a23ba7f5cd3537679"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e5cac25d08ea5220abd52e50f7828a798177b8040af51f22520929ff05c0cb39" => :sierra
    sha256 "8160c646113e6229af1924bc3d7d5a13803ed9ce4cc707f42b10e7f01cf9c245" => :el_capitan
    sha256 "ac0808e210af681f189f67c6ea02d03f9581d77c86ee40518fb511c340f88641" => :yosemite
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

  def install
    ENV.cxx11

    args = std_cmake_args
    args << "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}"
    args << "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib}/libjpeg.dylib"

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    assert_match(/Mapcrafter/,
      shell_output("#{bin}/mapcrafter --version"))
  end
end
