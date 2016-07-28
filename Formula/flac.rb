class Flac < Formula
  desc "Free lossless audio codec"
  homepage "https://xiph.org/flac/"
  url "http://downloads.xiph.org/releases/flac/flac-1.3.1.tar.xz"
  sha256 "4773c0099dba767d963fd92143263be338c48702172e8754b9bc5103efe1c56c"

  bottle do
    cellar :any
    revision 6
    sha256 "4f67258fce16d416d00e93ae9524b957e85d04e8e75f54262f980737298f8f13" => :el_capitan
    sha256 "9614d3d96d63d31cc9ebf7f672fabb5e7b95e0a3981e351105ebb5a352dc2681" => :yosemite
    sha256 "720080f90b4dae86bf3acaf507e0918b514a58ec661b052352ae10e0aba4ba77" => :mavericks
  end

  head do
    url "https://git.xiph.org/flac.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libogg" => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  fails_with :clang do
    build 500
    cause "Undefined symbols ___cpuid and ___cpuid_count"
  end

  def install
    ENV.universal_binary if build.universal?

    ENV.append "CFLAGS", "-std=gnu89"

    args = %W[
      --disable-dependency-tracking
      --disable-debug
      --prefix=#{prefix}
      --mandir=#{man}
      --enable-sse
      --enable-static
    ]

    args << "--disable-asm-optimizations" if build.universal? || Hardware.is_32_bit?
    args << "--without-ogg" if build.without? "libogg"

    system "./autogen.sh" if build.head?
    system "./configure", *args

    ENV["OBJ_FORMAT"] = "macho"

    # adds universal flags to the generated libtool script
    inreplace "libtool", ":$verstring\"", ":$verstring -arch #{Hardware::CPU.arch_32_bit} -arch #{Hardware::CPU.arch_64_bit}\""

    system "make", "install"
  end

  test do
    raw_data = "pseudo audio data that stays the same \x00\xff\xda"
    (testpath/"in.raw").write raw_data
    # encode and decode
    system "#{bin}/flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8", "--sample-rate=8000", "--output-name=in.flac", "in.raw"
    system "#{bin}/flac", "--decode", "--force-raw", "--endian=little", "--sign=signed", "--output-name=out.raw", "in.flac"
    # diff input and output
    system "diff", "in.raw", "out.raw"
  end
end
