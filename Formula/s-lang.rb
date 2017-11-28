class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "https://www.jedsoft.org/slang/"
  url "https://www.jedsoft.org/releases/slang/slang-2.3.1a.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.3.1a.tar.bz2/sha512/e7236a189081ebcbaf4e7f0506671226a4d46aede8826e1a558f1a2f57bcbe3ad58eadeabe2df99cd3d8bacb4c93749996bcbce4f51d338fc9396e0f945933e7/slang-2.3.1a.tar.bz2"
  sha256 "54f0c3007fde918039c058965dffdfd6c5aec0bad0f4227192cc486021f08c36"

  bottle do
    rebuild 1
    sha256 "9519dadec883d51288fdf41a4321cf838402cec1bf9d861b9f94afb2777d4faa" => :high_sierra
    sha256 "ac67492ea98625437fe6cbb1dc8207817575b0918262eada737e8442c73a8bc5" => :sierra
    sha256 "880bf3e4a4051cb3a25d386c4f486117e5d40fdc21b77a55812d039eeb01f203" => :el_capitan
  end

  depends_on "libpng"
  depends_on "pcre" => :optional
  depends_on "oniguruma" => :optional

  def install
    png = Formula["libpng"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png.lib}",
                          "--with-pnginc=#{png.include}"
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "Hello World!", shell_output("#{bin}/slsh -e 'message(\"Hello World!\");'").strip
  end
end
