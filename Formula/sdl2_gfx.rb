class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "https://www.ferzkopp.net/wordpress/2016/01/02/sdl_gfx-sdl2_gfx/"
  url "https://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.4.tar.gz"
  sha256 "63e0e01addedc9df2f85b93a248f06e8a04affa014a835c2ea34bfe34e576262"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6430b489e48700bd123fe97047c29d61ab2b2acdeb30e66088aa1ff25c109ca3" => :high_sierra
    sha256 "ceec21877e76ed307536daa50220c6a198dc8a5b53f734ad10d56715ce06fafc" => :sierra
    sha256 "79233dd99c8b35807f5869e90246f272b493bbe499e16dd338ba7c2ec2b57c1c" => :el_capitan
  end

  depends_on "sdl2"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL2_imageFilter.h>

      int main()
      {
        int mmx = SDL_imageFilterMMXdetect();
        return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lsdl2_gfx", "test.c", "-o", "test"
    system "./test"
  end
end
