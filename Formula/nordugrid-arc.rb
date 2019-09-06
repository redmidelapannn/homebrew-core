class NordugridArc < Formula
  desc "Grid computing middleware"
  homepage "http://www.nordugrid.org/"
  url "https://download.nordugrid.org/packages/nordugrid-arc/releases/6.1.0/src/nordugrid-arc-6.1.0.tar.gz"
  sha256 "dca3e212d7522ca443ad88180859fc24bc3058fa3e40f47508e50fe7918d6248"

  bottle do
    sha256 "704be50cf28cb6ef2a40fb4782ff7160783d596de153fdf89057389f5d93ed5d" => :mojave
    sha256 "565c47f4c87148efae86339739dde4af9c4204febdc9d6310da8eb506ae104f9" => :high_sierra
    sha256 "509ea260ebc19b65357d6afdd8fc303bb1ec6073633faba390fe64419d0939d0" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "globus-toolkit"
  depends_on "libxml2"

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-swig",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write("data")
    system "#{bin}/arccp", "foo", "bar"
  end
end
