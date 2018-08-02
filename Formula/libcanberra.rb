class Libcanberra < Formula
  desc "Implementation of XDG Sound Theme and Name Specifications"
  homepage "http://0pointer.de/lennart/projects/libcanberra/"

  stable do
    url "http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
    sha256 "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"

    depends_on "gtk-doc" => :optional
  end

  bottle do
    rebuild 1
    sha256 "941d57ed8a02742d86757bfd6e5ad0dc17aa2e2dbd28f701f998e7d511c40b7c" => :high_sierra
    sha256 "f51b6ec82af7070abe17dbc4ecc43079c006a15ae513f2873b0471feae0e1333" => :sierra
    sha256 "c12ca2c05f84d70faafd3fdc7231b3f3a80ef7b66b35403a8dc35bdda1328db0" => :el_capitan
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
  depends_on "pulseaudio" => :optional
  depends_on "gstreamer" => :optional

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
