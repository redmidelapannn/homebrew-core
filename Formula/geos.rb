class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.6.2.tar.bz2"
  sha256 "045a13df84d605a866602f6020fc6cbf8bf4c42fb50de237a08926e1d7d7652a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "36bffa345ed6738645c2034d53965e7b4acc0a39feb4dc3cf811ea068aba30e2" => :high_sierra
    sha256 "11ecc1befadf9ddf5440f338503c958e69a22cff80e17ac3ecf96c5b7c7b134b" => :sierra
    sha256 "6d2ad89e65ae39f26fa0acf79d983ffa29f36d3fb4ceaf8cf47a75ee2f7486f7" => :el_capitan
  end

  depends_on "swig" => :build
  depends_on "python@2"

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
