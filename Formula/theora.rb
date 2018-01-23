class Theora < Formula
  desc "Open video compression format"
  homepage "https://www.theora.org/"
  url "https://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.bz2"
  sha256 "b6ae1ee2fa3d42ac489287d3ec34c5885730b1296f0801ae577a35193d3affbc"

  bottle do
    cellar :any
    rebuild 3
    sha256 "cdbb07a4a7784d31af398e164f700d100fda174a97e6397de526a579bf90b127" => :high_sierra
    sha256 "147b0ec79a57193af89a7a30906ff660c32098d07d32a05a4dd66f750d0605f0" => :sierra
    sha256 "20b7e5015c10d35dcd7967a77bfd4cc08598d503b26126c5de68533c24239d87" => :el_capitan
  end

  devel do
    url "https://downloads.xiph.org/releases/theora/libtheora-1.2.0alpha1.tar.xz"
    sha256 "5be692c6be66c8ec06214c28628d7b6c9997464ae95c4937805e8057808d88f7"
  end

  head do
    url "https://git.xiph.org/theora.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    cp Dir["#{Formula["libtool"].opt_share}/libtool/*/config.{guess,sub}"], buildpath
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-oggtest
      --disable-vorbistest
      --disable-examples
    ]

    args << "--disable-asm" unless build.stable?

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <theora/theora.h>

      int main()
      {
          theora_info inf;
          theora_info_init(&inf);
          theora_info_clear(&inf);
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-ltheora", "test.c", "-o", "test"
    system "./test"
  end
end
