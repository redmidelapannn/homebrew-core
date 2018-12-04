class Nuttcp < Formula
  desc "Network performance measurement tool"
  homepage "https://www.nuttcp.net/nuttcp"
  url "https://www.nuttcp.net/nuttcp/nuttcp-8.1.4.tar.bz2"
  sha256 "737f702ec931ec12fcf54e66c4c1d5af72bd3631439ffa724ed2ac40ab2de78d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a207717db0bec7da8a88059f63589c3f50f93fd935c267f15e99ceb89aa4125c" => :mojave
    sha256 "46c3851144d50f7625475fc9fdeb96cd0ed4ff3a8770e0f52f9c40c541d843de" => :high_sierra
    sha256 "77c9c39b8f7253ce8d2a934702fcab4fa6c6b907d02f420837cdeaf527d80bd7" => :sierra
  end

  def install
    system "make", "APP=nuttcp",
           "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "nuttcp"
    man8.install "nuttcp.cat" => "nuttcp.8"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nuttcp -V")
  end
end
