class Cctools < Formula
  desc "Binary and cross-compilation tools for Apple"
  homepage "https://opensource.apple.com/"

  if MacOS.version >= :snow_leopard
    url "https://opensource.apple.com/tarballs/cctools/cctools-895.tar.gz"
    sha256 "ce66034fa35117f9ae76bbb7dd72d8068c405778fa42e877e8a13237a10c5cb7"
  else
    # 806 (from Xcode 4.1) is the latest version that supports Tiger or PowerPC
    url "https://opensource.apple.com/tarballs/cctools/cctools-806.tar.gz"
    sha256 "6116c06920112c634f6df2fa8b2f171ee3b90ff2176137da5856336695a6a676"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "158c99b7f169c1a8b3b91fd639730c8f9f3fba7fc055b6e97e8a35bb263ec0b6" => :high_sierra
    sha256 "075a3a828d3408f8e509a8fc070f68c25e1f6b704cdcfbfadbc8e641ce3ab988" => :sierra
    sha256 "42af2245744f33bea6c104f66c662c908d0d1510c1796cd0954d6c2a64a48411" => :el_capitan
  end

  keg_only :provided_by_macos, "this package duplicates tools shipped by Xcode"

  depends_on :ld64

  cxxstdlib_check :skip

  if MacOS.version >= :snow_leopard
    option "with-llvm", "Build with LTO support"
    depends_on "llvm" => :optional

    # These patches apply to cctools 855, for newer OSes
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/cctools-829-lto.patch"
      sha256 "8ed90e0eef2a3afc810b375f9d3873d1376e16b17f603466508793647939a868"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/PR-37520.patch"
      sha256 "921cba3546389809500449b08f4275cfd639295ace28661c4f06174b455bf3d4"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/cctools-839-static-dis_info.patch"
      sha256 "f49162b5c5d2753cf19923ff09e90949f01379f8de5604e86c59f67441a1214c"
    end

    # Fix building strings with LTO disabled
    patch :p0 do
      url "https://gist.githubusercontent.com/al3xtjames/8d68ef87c4c2138ef89d3d6e20879401/raw/d178e955c0f6cfcb91d775c016cb5ad95da43db0/cctools-895-strings-no-lto.diff"
      sha256 "885302f6573d7bf472f7bff4600b6387234df9aea8cd4187e736e0fe89551eab"
    end

    # Fix objdump/llvm-objdump paths in otool
    patch :p0 do
      url "https://gist.githubusercontent.com/al3xtjames/ac4096fa2508af7024ba410fef67b9df/raw/38752e5c4353b59589842e93f3cf3007e1d06e6e/cctools-895-otool-objdump-path.diff"
      sha256 "3616ae52100f5cd04909eb500dd5f091a1f29d9179bbd4d74f4977b7e6c3d69a"
    end

    # strnlen patch only needed on Snow Leopard
    if MacOS.version == :snow_leopard
      patch :p0 do
        url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/snowleopard-strnlen.patch"
        sha256 "b118f94411ad194596102f230abafa2f20262343ab36f2a578c6bdc1ae83ae12"
      end
    end
  else
    depends_on "cctools-headers" => :build

    # This set of patches only applies to cctools 806, for older OSes
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/cctools-806-lto.patch"
      sha256 "a92f38f0c34749b0988d4bfec77dec3ce3fc27d50a2cf9f3aaffa4277386470c"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/PR-9087924.patch"
      sha256 "6020933a25196660c2eb09d06f2cc4c2b5d67158fd2d99c221a17b63111ff391"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/PR-9830754.patch"
      sha256 "092e2762328477227f9589adf14c14945ebe6f266567deef16754ccc2ecb352d"
    end

    # Despite the patch name this is needed on 806 too
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/cctools-822-no-lto.patch"
      sha256 "535fe18d8842b03d23b0be057905f4f685d63b9c6436227b623b7aecd8e6ea83"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/PR-11136237.patch"
      sha256 "a19685c8870bdf270ed0fb8240985d87556be07eef14920ea782e2f5ec076759"
    end

    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/db27850/cctools/PR-12475288.patch"
      sha256 "2883e782094e05cbe5bc5a9f672aa775bc23ca0c77d2ecaa931be8b39e3525cb"
    end
  end

  def install
    ENV.deparallelize # see https://github.com/mistydemeo/tigerbrew/issues/102

    if build.with? "llvm"
      inreplace "libstuff/lto.c", "@@LLVM_LIBDIR@@", Formula["llvm"].opt_lib
    end

    if MacOS.version >= :snow_leopard
      inreplace "misc/Makefile", "$(RAW_DSTROOT)/usr/libexec/DeveloperTools", "$(DSTROOT)/libexec/DeveloperTools"
      inreplace "otool/main.c", "@@CLT_BINDIR@@", "/Library/Developer/CommandLineTools/usr/bin"

      if build.with? "llvm"
        inreplace "as/driver.c", "makestr(prefix, CLANG, NULL)", "makestr(\"#{Formula["llvm"].opt_bin}/\", CLANG, NULL)"
        inreplace "otool/main.c", "@@LLVM_BINDIR@@", Formula["llvm"].opt_bin
      else
        inreplace "as/driver.c", "makestr(prefix, CLANG, NULL)", "makestr(\"/Library/Developer/CommandLineTools/usr/bin/\", CLANG, NULL)"
      end
    end

    args = %W[
      RC_ProjectSourceVersion=#{version}
      USE_DEPENDENCY_FILE=NO
      BUILD_DYLIBS=NO
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      LTO=#{"-DLTO_SUPPORT" if build.with? "llvm"}
      RC_CFLAGS=#{ENV.cflags}
      TRIE=
      RC_OS="macos"
      DSTROOT=#{prefix}
    ]

    # Fixes build with gcc-4.2: https://trac.macports.org/ticket/43745
    args << "SDK=-std=gnu99"

    if Hardware::CPU.intel?
      archs = "i386 x86_64"
    else
      archs = "ppc i386 x86_64"
    end
    args << "RC_ARCHS=#{archs}"

    system "make", "install_tools", *args

    # cctools installs into a /-style prefix in the supplied DSTROOT,
    # so need to move the files into the standard paths.
    # Also merge the /usr and /usr/local trees.
    man.install Dir["#{prefix}/usr/local/man/*"]
    prefix.install Dir["#{prefix}/usr/local/*"]
    bin.install Dir["#{prefix}/usr/bin/*"]
    (include/"mach-o").install Dir["#{prefix}/usr/include/mach-o/*"]
    man1.install Dir["#{prefix}/usr/share/man/man1/*"]
    man3.install Dir["#{prefix}/usr/share/man/man3/*"]
    man5.install Dir["#{prefix}/usr/share/man/man5/*"]

    # These install locations changed between 806 and 855
    if MacOS.version >= :snow_leopard
      (libexec/"as").install Dir["#{prefix}/usr/libexec/as/*"]
    else
      (libexec/"gcc/darwin").install Dir["#{prefix}/usr/libexec/gcc/darwin/*"]
      share.install Dir["#{prefix}/usr/share/gprof.*"]
    end
  end

  def caveats; <<~EOS
    cctools's version of ld was not built.
    EOS
  end

  test do
    assert_match "/usr/lib/libSystem.B.dylib", shell_output("#{bin}/otool -L #{bin}/install_name_tool")
  end
end
