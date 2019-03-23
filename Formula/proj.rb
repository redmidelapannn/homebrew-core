class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj4.org/"
  url "https://download.osgeo.org/proj/proj-6.0.0.tar.gz"
  sha256 "4510a2c1c8f9056374708a867c51b1192e8d6f9a5198dd320bf6a168e44a3657"

  bottle do
    sha256 "2bf75e5c6feef41d4e49349064e9f4cb5f4458f92c1f6fddaf29447133f78e87" => :mojave
    sha256 "a39d397d3fcfddca26345a2a80cee9efee4616a267403f653852b0c2547dd188" => :high_sierra
    sha256 "e0d6ed9ae3cdaa1e392e410fef31420a2ec5cdff15ada65eb5ecd73a848fe497" => :sierra
  end

  head do
    url "https://github.com/OSGeo/proj.4.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  conflicts_with "blast", :because => "both install a `libproj.a` library"

  skip_clean :la

  # The datum grid files are required to support datum shifting
  resource "datumgrid" do
    url "https://download.osgeo.org/proj/proj-datumgrid-1.8.zip"
    sha256 "b9838ae7e5f27ee732fb0bfed618f85b36e8bb56d7afb287d506338e9f33861e"
  end

  def install
    (buildpath/"nad").install resource("datumgrid")

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test").write <<~EOS
      45d15n 71d07w Boston, United States
      40d40n 73d58w New York, United States
      48d51n 2d20e Paris, France
      51d30n 7'w London, England
    EOS
    match = <<~EOS
      -4887590.49\t7317961.48 Boston, United States
      -5542524.55\t6982689.05 New York, United States
      171224.94\t5415352.81 Paris, France
      -8101.66\t5707500.23 London, England
    EOS
    assert_equal match,
                 `#{bin}/proj +proj=poly +ellps=clrk66 -r #{testpath}/test`
  end
end
