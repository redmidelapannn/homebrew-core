class Libheif < Formula
  desc "ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
  homepage "https://www.libde265.org/"
  url "https://github.com/strukturag/libheif/releases/download/v1.5.1/libheif-1.5.1.tar.gz"
  sha256 "b134d0219dd2639cc13b8a8bcb8f264834593dd0417da1973fbe96e810918a8b"
  revision 1

  bottle do
    cellar :any
    sha256 "b0ff837baa88401c52419d10669c72cc945028c465027ba88125fc59dc77cf8b" => :catalina
    sha256 "e6ed6a1c1002d55a3436a1f42b0903dde7d880353ce970de5a222d12c0b13956" => :mojave
    sha256 "db0a8ff21c4d0ebb28f63cbd905bd255a4dab06c7d4fa63631eb03d2c100f283" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libde265"
  depends_on "libpng"
  depends_on "shared-mime-info"
  depends_on "x265"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "examples/example.heic"
  end

  def post_install
    system Formula["shared-mime-info"].opt_bin/"update-mime-database", "#{HOMEBREW_PREFIX}/share/mime"
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
