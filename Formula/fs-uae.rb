class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"

  stable do
    url "https://fs-uae.net/stable/2.8.1u3/fs-uae-2.8.1u3.tar.gz"
    version "2.8.1u3"
    sha256 "7cc84844a77853f4fe2f2fc7da20ce94adc1a0c0c4b982ea28852a60b8a4d83a"
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "5effab2e2483c0db3689d4a3da3654dceed843f3a27e34c77783f64f36fe72f4" => :sierra
    sha256 "b2fb746d555db02d20af12f3a97f03c6510a6cd652cc1b2200bbcbde8d77dfdb" => :el_capitan
    sha256 "b06c287fce7bf98ea702086fe50c54f7cb31bdb58ca6a083d9b8a815a4cfc918" => :yosemite
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "libpng"
  depends_on "libmpeg2"
  depends_on "glib"
  depends_on "gettext"
  depends_on "freetype"
  depends_on "glew"
  depends_on "openal-soft" if MacOS.version <= :mavericks

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unncessary files
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"mime").rmtree
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
