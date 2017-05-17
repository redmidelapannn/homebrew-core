class KitchenSync < Formula
  desc "Fast efficiently sync database without dumping & reloading"
  homepage "https://github.com/willbryant/kitchen_sync"
  url "https://github.com/willbryant/kitchen_sync/archive/0.58.tar.gz"
  sha256 "56c39c55d9db5576adc2197cbf2c0cc79b77c5a225d53b7f0b4c2bd9d1f37590"
  head "https://github.com/willbryant/kitchen_sync.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "67f40e9affe8571163b064298fbe92923cd40e5ee2f28f8d99224b3585a6decc" => :sierra
    sha256 "fc1590a89779d380921949a7d6a728a503a7fd5cad56258a3010f71e77584e89" => :el_capitan
    sha256 "12a787e07cfe75aea2ffa6f2289fae4650b61c66ac79d41ca5e70debd7f70c4c" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "yaml-cpp"

  depends_on :mysql => :recommended
  depends_on :postgresql => :optional
  depends_on "mariadb" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/ks --from a://b/ --to c://d/ 2>&1")
    assert_match "Finished Kitchen Syncing", output
  end
end
