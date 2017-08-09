class Istio < Formula
  desc "Sample code, build, tests and governance material for the Istio project."
  homepage "https://istio.io"
  url "https://github.com/istio/istio/releases/download/0.1.6/istio-0.1.6-osx.tar.gz"
  sha256 "347904068bb6100aa15b2a030be872687143b86d8529c790212517405ddb0582"

  bottle do
    cellar :any_skip_relocation
    sha256 "c19c9673d57bdad31349c7558aff07901a183093fd73754dc8448e44d457030a" => :sierra
    sha256 "c19c9673d57bdad31349c7558aff07901a183093fd73754dc8448e44d457030a" => :el_capitan
    sha256 "c19c9673d57bdad31349c7558aff07901a183093fd73754dc8448e44d457030a" => :yosemite
  end

  def install
    bin.install "bin/istioctl"
  end

  test do
    system "#{bin}/istioctl", "--help"
  end
end
