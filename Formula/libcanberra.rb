class Libcanberra < Formula
  desc "Implementation of XDG Sound Theme and Name Specifications"
  homepage "http://0pointer.de/lennart/projects/libcanberra/"
  url "http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
  sha256 "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"

  bottle do
    rebuild 1
    sha256 "1ee9d15ac5df40018bb3c36701d6053321a23f6e0b6fb3bf6105aac8ffb53f3b" => :mojave
    sha256 "575d9187251d721551d16bd86357141492f91c3ac6e11c35b4a2fe05f254074a" => :high_sierra
    sha256 "b1ffada79ebd9f4eeea6087406f89d764604b2d39ff7afb8a34995369cfac488" => :sierra
    sha256 "4c8b3bae89aa5bab3477375188d1c98d0345f0dfc1b831de41712ae91f7a46a5" => :el_capitan
  end

  head do
    url "git://git.0pointer.de/libcanberra"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libvorbis"

  def install
    system "./autogen.sh" if build.head?

    # ld: unknown option: --as-needed" and then the same for `--gc-sections`
    # Reported 7 May 2016: lennart@poettering.net and mzyvopnaoreen@0pointer.de
    system "./configure", "--prefix=#{prefix}", "--no-create"
    inreplace "config.status", "-Wl,--as-needed -Wl,--gc-sections", ""
    system "./config.status"

    system "make", "install"
  end

  test do
    (testpath/"lc.c").write <<~EOS
      #include <canberra.h>
      int main()
      {
        ca_context *ctx = NULL;
        (void) ca_context_create(&ctx);
        return (ctx == NULL);
      }
    EOS
    system ENV.cc, "lc.c", "-I#{include}", "-L#{lib}", "-lcanberra", "-o", "lc"
    system "./lc"
  end
end
