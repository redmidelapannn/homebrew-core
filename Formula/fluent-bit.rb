class FluentBit < Formula
  desc "Data Collector for IoT"
  homepage "https://github.com/fluent/fluent-bit"
  url "https://github.com/fluent/fluent-bit/archive/v1.2.2.tar.gz"
  sha256 "c14bd6d327afc852c636cc0ebef67001328bac31ea164339b5b58bacab7bdf60"
  head "https://github.com/fluent/fluent-bit.git"

  bottle do
    cellar :any
    sha256 "3bdc3e78bb212eb65bdb4e5748603b49b4d5adb79910875253ce016b537568b5" => :mojave
    sha256 "42120d4f5590658503c40fdeee61de2e10be972c9137bc25cf7b0aef2ff0ffe7" => :high_sierra
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build

  conflicts_with "mbedtls", :because => "fluent-bit includes mbedtls libraries."
  conflicts_with "msgpack", :because => "fluent-bit includes msgpack libraries."

  def install
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
