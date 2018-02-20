class Istio < Formula
  desc "Istio configuration command line utility"
  homepage "https://istio.io"
  url "https://github.com/istio/istio/releases/download/0.5.0/istio-0.5.0-osx.tar.gz"
  sha256 "34c3f2cab1d25f99dd8b411e97c7eb5a527d44c77775ff0ee4c26ad531564373"

  bottle do
    cellar :any_skip_relocation
    sha256 "91b307c61f213dc5aafb26d8aae624c340c2b2499d74c18aeb4db1f748e1d523" => :high_sierra
    sha256 "91b307c61f213dc5aafb26d8aae624c340c2b2499d74c18aeb4db1f748e1d523" => :sierra
    sha256 "91b307c61f213dc5aafb26d8aae624c340c2b2499d74c18aeb4db1f748e1d523" => :el_capitan
  end

  def install
    bin.install "bin/istioctl"
  end

  test do
    system "#{bin}/istioctl", "--help"
  end
end
