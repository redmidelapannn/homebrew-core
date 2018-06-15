class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "http://www.libheif.org"
  url "https://github.com/strukturag/libheif/releases/download/v1.2.0/libheif-1.2.0.tar.gz"
  sha256 "2e7d40f81d1bbe6089b1e0f27800b97cf6a195e093ef86199edfb6e59e2fa8fa"
  head "https://github.com/strukturag/libheif.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "b7b51fc14e90556714d274d1fd067796fdca7d8c9ab880ba92ce3228529a4389" => :high_sierra
    sha256 "ec32074d5cf7c166b6e9ade79ff90423263d9e95914eb905bff2d617344c2e46" => :sierra
    sha256 "b9b8e83e7006062d8e4bc1ddf3fe5aed5c619eafb1844e54c49ca1fc128d8b5e" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "x265"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples/example.heic"
  end

  test do
    output = "File contains 2 images"
    example = pkgshare/"example.heic"
    exout = testpath/"example.jpg"

    assert_match output, shell_output("#{bin}/heif-convert #{example} #{exout}")
    assert_predicate testpath/"example-1.jpg", :exist?
    assert_predicate testpath/"example-2.jpg", :exist?
  end
end
