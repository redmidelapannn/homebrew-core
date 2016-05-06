class LibsvgCairo < Formula
  desc "SVG rendering library using Cairo"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/snapshots/libsvg-cairo-0.1.6.tar.gz"
  sha256 "a380be6a78ec2938100ce904363815a94068fca372c666b8cc82aa8711a0215c"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha256 "087f0a756d6136fb37eb57d61041b8ef4fea0ae889d62c78b55e644dd06de0ae" => :el_capitan
    sha256 "b0004115dbc9d113777e4ef62ef29244b78c6e1954b6dc140dcea6cc092afb24" => :yosemite
    sha256 "acdd325a18fac5b463bb420355f72b9b78620c467257927cc375bace0a8c014d" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libsvg"
  depends_on "libpng"
  depends_on "cairo"

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
