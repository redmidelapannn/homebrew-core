class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/1.0.2/libbluray-1.0.2.tar.bz2"
  sha256 "6d9e7c4e416f664c330d9fa5a05ad79a3fb39b95adfc3fd6910cbed503b7aeff"

  bottle do
    cellar :any
    rebuild 1
    sha256 "209e434c90deea03320de1fa8786da34e37cd7be3207ea03c46de3010e6ab8cf" => :high_sierra
    sha256 "4a79e39ca36e11f796ec82dee6042a593afd81928793fa4b4a830294e895f761" => :sierra
    sha256 "109479a48ce04d4d313fa9aa19e4dbf4eeffe6d13d320e82f465bc30a9b09e11" => :el_capitan
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
  depends_on "freetype" => :recommended

  def install
    # Need to set JAVA_HOME manually since ant overrides 1.8 with 1.8+
    cmd = Language::Java.java_home_cmd("1.8")
    ENV["JAVA_HOME"] = Utils.popen_read(cmd).chomp

    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-freetype" if build.without? "freetype"

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
