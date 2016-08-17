class Libcanberra < Formula
  desc "Implementation of XDG Sound Theme and Name Specifications"
  homepage "http://0pointer.de/lennart/projects/libcanberra/"

  stable do
    url "http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz"
    sha256 "c2b671e67e0c288a69fc33dc1b6f1b534d07882c2aceed37004bf48c601afa72"

    depends_on "gtk-doc" => :optional
  end
  bottle do
    revision 1
    sha256 "3a525f3e42b9c5f1e0413432fe33670ec3d1cd9e3ed17153668df1817a8e0951" => :el_capitan
    sha256 "855af5ffd96a3600fde2797f85a1298766bd38c5a7faa5e2be927973ce14a595" => :yosemite
    sha256 "b014b43fca010176ba36d20293a080c2854f574571d2ccf3f4d14e8a5a6574a7" => :mavericks
  end

  head do
    url "git://git.0pointer.de/libcanberra"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk-doc"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libvorbis"
  depends_on "pulseaudio" => :optional
  depends_on "gstreamer" => :optional
  depends_on "gtk+" => :optional
  depends_on "gtk+3" => :optional

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
    (testpath/"lc.c").write <<-EOS.undent
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
