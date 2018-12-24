class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20181223.tar.gz"
  sha256 "e40cb6a33e519c78c0747638e0503ba7b5a4aadf73a04e33ee5246210b549540"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "be0d3f85b4676c471c81ca801a063399bfac22e88d4e6eb0a812c5d6f1afc477" => :mojave
    sha256 "46ede7cf073251a300fe12a7cc3adb1e2adbb55d4d4360bb5f1fc8b174a647ac" => :high_sierra
    sha256 "33b06654004c1d9193ef5d225328fcf4d28e3e01fa8fd66a958bf817fcc90600" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libsigc++"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"

  needs :cxx11

  def install
    ENV.cxx11
    ENV["PIONEER_DATA_DIR"] = "#{pkgshare}/data"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-version=#{version}"
    system "make", "install"
  end

  test do
    assert_equal "#{name} #{version}", shell_output("#{bin}/pioneer -v 2>&1").chomp
    assert_equal "modelcompiler #{version}", shell_output("#{bin}/modelcompiler -v 2>&1").chomp
  end
end
