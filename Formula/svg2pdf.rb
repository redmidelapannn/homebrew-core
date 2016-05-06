class Svg2pdf < Formula
  desc "Renders SVG images to a PDF file (using Cairo)"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/svg2pdf-0.1.3.tar.gz"
  sha256 "854a870722a9d7f6262881e304a0b5e08a1c61cecb16c23a8a2f42f2b6a9406b"

  bottle do
    cellar :any
    revision 1
    sha256 "186f583b57d9e1173b0a0c4cef1a60d57ef6bd062482a74d996d9619744d317e" => :el_capitan
    sha256 "d0e7ad2dad2908279dd3e56113e9c80421139c6357e3edd4273454a1ad6df297" => :yosemite
    sha256 "2bc924466ba17a1bb8b6b4d4d51beb4a202ba46853a22c107d55937f00594b8e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg-cairo"

  resource("svg.svg") do
    url "https://raw.githubusercontent.com/mathiasbynens/small/master/svg.svg"
    sha256 "900fbe934249ad120004bd24adf66aad8817d89586273c0cc50e187bddebb601"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    resource("svg.svg").stage do
      system "#{bin}/svg2pdf", "svg.svg", "test.pdf"
      assert File.exist? "test.pdf"
    end
  end
end
