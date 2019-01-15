class Proj < Formula
  desc "Cartographic Projections Library"
  homepage "https://proj4.org/"
  url "https://download.osgeo.org/proj/proj-5.2.0.tar.gz"
  sha256 "ef919499ffbc62a4aae2659a55e2b25ff09cccbbe230656ba71c6224056c7e60"

  bottle do
    rebuild 1
    sha256 "31b6721a36b8c013ce746584124bcc0bebce615a687dd974666ae23f6fe65064" => :mojave
    sha256 "bb3fb88b11386f71038de98a756b65d418affd8530bf7a02dc07b49c0c740184" => :high_sierra
    sha256 "25f6e4d64d32d37b12bbf1008a973385aa464b90430ee0700446b1afb8bc24da" => :sierra
  end

  head do
    url "https://github.com/OSGeo/proj.4.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

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
