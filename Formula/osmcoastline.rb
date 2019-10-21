class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.2.4.tar.gz"
  sha256 "7a399661b46e4e700b11d6a5163ec7bdc8ad49f0837b524f1f2535cca7b9ee43"

  bottle do
    cellar :any
    sha256 "83e62c7b47703385c47615ef84a4c0b35ecce5fd0a53e299e7111dd0d377578d" => :catalina
    sha256 "2c47dd8a8b33920e60bc14ed9bf43eb09c638c35f4ec245af2a994082fefa258" => :mojave
    sha256 "ebf1dbec28cb28865e6fe451547eb8398c431264b3f595e1ac106a5f471c97bb" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"

  uses_from_macos "zlib"
  uses_from_macos "sqlite"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"input.opl").write <<~EOS
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    EOS
    system "#{bin}/osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
