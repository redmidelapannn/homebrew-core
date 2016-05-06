class Libepoxy < Formula
  desc "Library for handling OpenGL function pointer management"
  homepage "https://github.com/anholt/libepoxy"
  url "https://github.com/anholt/libepoxy/archive/v1.3.1.tar.gz"
  sha256 "6700ddedffb827b42c72cce1e0be6fba67b678b19bf256e1b5efd3ea38cc2bb4"

  bottle do
    cellar :any
    revision 1
    sha256 "488c027ab527991bd1a5cd56e8a2e84ccfb10624927b0a6fd4bcadc138cf016a" => :el_capitan
    sha256 "69a4b4008b1349837cce9ad61549813b791ba9146a183654e249000bd9c922ad" => :yosemite
    sha256 "4b525499c1beb42ec4a574aed4aa046d9fa4d7caf6b9f27db89236c05145bb91" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard

  resource "xorg-macros" do
    url "https://xorg.freedesktop.org/releases/individual/util/util-macros-1.19.0.tar.bz2"
    sha256 "2835b11829ee634e19fa56517b4cfc52ef39acea0cd82e15f68096e27cbed0ba"
  end

  def install
    ENV.universal_binary if build.universal?

    resource("xorg-macros").stage do
      system "./configure", "--prefix=#{buildpath}/xorg-macros"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{buildpath}/xorg-macros/share/pkgconfig"
    ENV.append_path "ACLOCAL_PATH", "#{buildpath}/xorg-macros/share/aclocal"

    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent

      #include <epoxy/gl.h>
      #include <OpenGL/CGLContext.h>
      #include <OpenGL/CGLTypes.h>
      int main()
      {
          CGLPixelFormatAttribute attribs[] = {0};
          CGLPixelFormatObj pix;
          int npix;
          CGLContextObj ctx;

          CGLChoosePixelFormat( attribs, &pix, &npix );
          CGLCreateContext(pix, (void*)0, &ctx);

          glClear(GL_COLOR_BUFFER_BIT);
          CGLReleasePixelFormat(pix);
          CGLReleaseContext(pix);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lepoxy", "-framework", "OpenGL", "-o", "test"
    system "ls", "-lh", "test"
    system "file", "test"
    system "./test"
  end
end
