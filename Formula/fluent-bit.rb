class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.4.2.tar.gz"
  sha256 "71764ce8b111975e4749864d57d04977cfc0ba9e6729be659392cf5b7c4aaafc"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "de692247f7e626f3285146d9fe274f95b3129747ba52481c51d9b48e96f3215f" => :catalina
    sha256 "5102fee7a0539dc1783144544013f57e44aa90fdbbe1fed19c7e051933e6402f" => :mojave
    sha256 "68ae74fa7643bc4d25c0d6dff75ab28d58694c1cc4e7ec98d9129ca047de0fca" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    # Per https://luajit.org/install.html: If MACOSX_DEPLOYMENT_TARGET
    # is not set then it's forced to 10.4, which breaks compile on Mojave.
    # fluent-bit builds against a vendored Luajit.
    ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

    system "cmake", ".", "-DWITH_IN_MEM=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fluent-bit -V").chomp
    assert_equal "Fluent Bit v#{version}", output
  end
end
