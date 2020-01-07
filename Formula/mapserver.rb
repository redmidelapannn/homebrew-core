class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.4.3.tar.gz"
  sha256 "c8cc4dc994b61d7bc5767419da40d7af9e7566669d6800e4c2d4e11a91656f45"
  revision 1

  bottle do
    cellar :any
    sha256 "1cf604925d2f37bd232c8477c3a96a661ac37b944b4a9a5ed38fc4cc9679d108" => :catalina
    sha256 "e995b39033d8c9f13d0c0012a7dbb9ae1bbf42dd9d033f946bc335ed3edf2aec" => :mojave
    sha256 "02e0c7cbf7d02e50017354a85bc5b18dc55acaef8295ddfef38fa4dc6c8e6772" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig@3" => :build
  depends_on "cairo"
  depends_on "fcgi"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gdal"
  depends_on "geos"
  depends_on "giflib"
  depends_on "libpng"
  depends_on "postgresql"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python"

  def install
    ENV.cxx11

    python_executable = Utils.popen_read("python3 -c 'import sys;print(sys.executable)'").chomp
    args = std_cmake_args + %w[
      -DWITH_CLIENT_WFS=ON
      -DWITH_CLIENT_WMS=ON
      -DWITH_CURL=ON
      -DWITH_FCGI=ON
      -DWITH_FRIBIDI=OFF
      -DWITH_GDAL=ON
      -DWITH_GEOS=ON
      -DWITH_HARFBUZZ=OFF
      -DWITH_KML=ON
      -DWITH_OGR=ON
      -DWITH_POSTGIS=ON
      -DWITH_PYTHON=ON
      -DWITH_SOS=ON
      -DWITH_WFS=ON
    ]
    args << "-DPYTHON_EXECUTABLE=#{python_executable}"
    args << "-DPHP_EXTENSION_DIR=#{lib}/php/extensions"

    # Install within our sandbox
    inreplace "mapscript/python/CMakeLists.txt" do |s|
      s.gsub! "${PYTHON_LIBRARIES}", "-Wl,-undefined,dynamic_lookup"
    end

    # Using rpath on python module seems to cause problems if you attempt to
    # import it with an interpreter it wasn't built against.
    # 2): Library not loaded: @rpath/libmapserver.1.dylib
    args << "-DCMAKE_SKIP_RPATH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "mapscript/python" do
        system "python3", *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system "python3", "-c", "import mapscript"
  end
end
