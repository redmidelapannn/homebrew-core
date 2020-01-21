class Pihelper < Formula
  desc "Unofficial command-line client for the Pi-hole"
  homepage "https://git.wbrawner.com/cgit.cgi/Pi-Helper/pihelper.git/about/"
  url "https://git.wbrawner.com/cgit.cgi/Pi-Helper/pihelper.git/snapshot/pihelper-0.1.0.tar.gz"
  sha256 "110f16e1e8167c18ce7c11fd5a8d73f016f0e5a9c4e5898f3b24bbdd878bafcb"

  bottle do
    sha256 "8e3c33a79fcc655234fee417c727eb279288a967c22c8e2fe9155667a1ca6145" => :catalina
    sha256 "485ec2b266d2b1ee3d855043ce86817d427d0729bd7ed029f2fb1ab1b7a8770f" => :mojave
    sha256 "b2c7105dbbf33d60588a03c94efa9e5a95f3c283afa83248d859910c6f6f1424" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "json-c"
  depends_on "openssl@1.1"
  uses_from_macos "curl"

  def install
    system "cmake", ".", "-DPIHELPER_EXECUTABLE=ON", "-DPIHELPER_STATIC=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    require "open3"
    File.write(Dir.pwd + "/tmp_file", "host=localhost\napi-key=test\n")
    Open3.popen3("#{bin}/pihelper", "-f", Dir.pwd + "/tmp_file") do |_, _, stderr|
      assert_equal "Failed to retrieve status for Pi-hole at localhost\n" + "\n", stderr.read
    end
  end
end
