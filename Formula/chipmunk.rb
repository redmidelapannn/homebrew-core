class Chipmunk < Formula
  desc "2D rigid body physics library written in C"
  homepage "http://chipmunk-physics.net/"
  url "http://chipmunk-physics.net/release/Chipmunk-7.x/Chipmunk-7.0.1.tgz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/chipmunk/Chipmunk-7.0.1.tgz"
  sha256 "fe54b464777d89882a9f9d3d6deb17189af8bc5d63833b25bb1a7d16c3e69260"

  head "https://github.com/slembcke/Chipmunk2D.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "5cf951dbd7e75dc4072ad458bc117fc36e6998fdbd935fdc1b0a3fed75ea79c0" => :sierra
    sha256 "8bfc56dbec5e0a9d62b8d661e607d41cdc83317c9f801f72ef6ae4e1d7cd80a7" => :el_capitan
    sha256 "661dae4645f6aa391d78f9b00a5604aec46447b8be55440deaf4df8658188b63" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", "-DBUILD_DEMOS=OFF", *std_cmake_args
    system "make", "install"

    doc.install Dir["doc/*"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <chipmunk.h>

      int main(void){
        cpVect gravity = cpv(0, -100);
        cpSpace *space = cpSpaceNew();
        cpSpaceSetGravity(space, gravity);

        cpSpaceFree(space);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/chipmunk", "-L#{lib}", "-lchipmunk",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
