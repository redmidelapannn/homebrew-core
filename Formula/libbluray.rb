class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/1.0.2/libbluray-1.0.2.tar.bz2"
  sha256 "6d9e7c4e416f664c330d9fa5a05ad79a3fb39b95adfc3fd6910cbed503b7aeff"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f3896ded76fbcd62ac10df60a9def15c1332a42f8a2e6caf613c3b78cd90ecbc" => :mojave
    sha256 "fcdf66c4de0bc439ddd563ee718e6ba52bc515447c810ae192eedb86714ec6d6" => :high_sierra
    sha256 "47cb777eba9da01841f28dbfcd04e661a3bd9b44ea39c28d6d359cb0e709eac4" => :sierra
    sha256 "9e5870552f308f20a602dd4096696de07ea2312306c769af1cc2992f3d32ecd4" => :el_capitan
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

  def install
    # Need to set JAVA_HOME manually since ant overrides 1.8 with 1.8+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

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
