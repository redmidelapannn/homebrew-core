class Ode < Formula
  desc "Simulating articulated rigid body dynamics"
  homepage "http://www.ode.org/"
  url "https://bitbucket.org/odedevs/ode/downloads/ode-0.15.2.tar.gz"
  sha256 "2eaebb9f8b7642815e46227956ca223806f666acd11e31708bd030028cf72bac"
  revision 1
  head "https://bitbucket.org/odedevs/ode/", :using => :hg

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "36e07ef225fdd5cd9899c4d2e293b28a710ace530c49d3afb1bb8d2d0023af19" => :high_sierra
    sha256 "ad908f457d983b8f4d8b8090beaac4f6d0d1abbe2a06945d16c41b4dfdbf78e2" => :sierra
    sha256 "015dab6733aac30823fa4e54b0c3257181cc61a5e5a08515ff5f7673b729696e" => :el_capitan
  end

  option "with-double-precision", "Compile ODE with double precision"
  option "with-shared", "Compile ODE with shared library support"
  option "with-x11", "Build the drawstuff library and demos"

  deprecated_option "enable-double-precision" => "with-double-precision"
  deprecated_option "enable-shared" => "with-shared"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libccd"
  depends_on :x11 => :optional

  def install
    args = ["--prefix=#{prefix}", "--enable-libccd"]
    args << "--enable-double-precision" if build.with? "double-precision"
    args << "--enable-shared" if build.with? "shared"
    args << "--with-demos" if build.with? "x11"

    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "./bootstrap"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ode/ode.h>
      int main() {
        dInitODE();
        dCloseODE();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-I#{include}/ode", "-L#{lib}", "-lode", "-lccd",
                   "-lc++", "-o", "test"
    system "./test"
  end
end
