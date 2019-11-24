class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/1.1.2/libbluray-1.1.2.tar.bz2"
  sha256 "a3dd452239b100dc9da0d01b30e1692693e2a332a7d29917bf84bb10ea7c0b42"

  bottle do
    cellar :any
    rebuild 2
    sha256 "f9994ea7900a9aced82befec7a10d940beeebcf1f9bfb2a27af8c2b3792e7dd0" => :catalina
    sha256 "201df5b16261c977d8fba3d999539fde9fd092186f521802ce36f7a2b28b1fa0" => :mojave
    sha256 "043e25b509eb0899d7f236d3067041a3a7926a5b6937d48393e761a8bb9cefc3" => :high_sierra
  end

  head do
    url "https://git.videolan.org/git/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "ant" => :build
  depends_on :java => ["1.8", :build]
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  uses_from_macos "libxml2"

  def install
    # Need to set JAVA_HOME manually since ant overrides 1.8 with 1.8+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    # Work around Xcode 11 clang bug
    # https://code.videolan.org/videolan/libbluray/issues/20
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbluray/bluray.h>
      int main(void) {
        BLURAY *bluray = bd_init();
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbluray", "-o", "test"
    system "./test"
  end
end
