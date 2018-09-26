class C10t < Formula
  desc "Minecraft cartography tool"
  homepage "https://github.com/udoprog/c10t"
  url "https://github.com/udoprog/c10t/archive/1.7.tar.gz"
  sha256 "0e5779d517105bfdd14944c849a395e1a8670bedba5bdab281a0165c3eb077dc"
  revision 1

  bottle do
    cellar :any
    sha256 "59b3636a2b44a57234e77b763df3c4462a05a976f79402c5f722ff53fe0b1300" => :mojave
    sha256 "3f0d07e77d96a90789f68eae74d23295739e838e4454428eeb442a5868e725b7" => :high_sierra
    sha256 "cd089cf2a2eb1227d371f4e3d002e07fd96cca084b5a3446fb88d5061cc4ef7f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "freetype"

  # Needed to compile against newer boost
  # Can be removed for the next version of c10t after 1.7
  # See: https://github.com/udoprog/c10t/pull/153
  patch do
    url "https://github.com/udoprog/c10t/commit/4a392b9f06d08c70290f4c7591e84ecdbc73d902.diff?full_index=1"
    sha256 "5e1c6d9906c3cf2aaaceca2570236585d3404ab4107cfb9169697e9cab30072d"
  end

  # Fix freetype detection; adapted from this upstream commit:
  # https://github.com/udoprog/c10t/commit/2a2b8e49d7ed4e51421cc71463c1c2404adc6ab1
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/f7ab02089c43dd557ef4/raw/a0ae7974e635b8ebfd02e314cfca9aa8dc95029d/c10t-freetype.diff"
    sha256 "9fbb7ccc643589ac1d648e105369e63c9220c26d22f7078a1f40b27080d05db4"
  end

  # Ensure zlib header is included for libpng; fixed upstream
  patch do
    url "https://github.com/udoprog/c10t/commit/800977bb23e6b4f9da3ac850ac15dd216ece0cda.diff?full_index=1"
    sha256 "5275cb43178b2f6915b14d214ec47c9182e63ff23771426b71f3c0a5450721bf"
  end

  def install
    inreplace "test/CMakeLists.txt", "boost_unit_test_framework", "boost_unit_test_framework-mt"
    system "cmake", ".", *std_cmake_args
    system "make"
    bin.install "c10t"
  end

  test do
    system "#{bin}/c10t", "--list-colors"
  end
end
