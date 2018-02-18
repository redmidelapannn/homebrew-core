class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.6.2.tar.bz2"
  sha256 "045a13df84d605a866602f6020fc6cbf8bf4c42fb50de237a08926e1d7d7652a"

  bottle do
    cellar :any
    rebuild 1
    sha256 "74b9b297cdb4dfd8b7eb1e5c903b6a8a097a823d1bd4fbf55416a240ca29bbb5" => :high_sierra
    sha256 "80a4a3f0e7aa3ad8aeac3c11da6bf09d4f524754ec3ec4509b7ac97a0ef80069" => :sierra
    sha256 "0a461c2c57448e340cd813552bd9481eeab266d677bc9a952e3fe97253ac87f2" => :el_capitan
  end

  option "without-python", "Do not build the Python extension"
  option "with-ruby", "Build the ruby extension"

  depends_on "swig" => :build if build.with?("python") || build.with?("ruby")

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    args << "--enable-python" if build.with?("python")
    args << "--enable-ruby" if build.with?("ruby")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
