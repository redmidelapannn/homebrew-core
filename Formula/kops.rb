class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.6.0.tar.gz"
  sha256 "483da291fc5a7a72c151e15ab586e6106f807564894669070705d2e1762e5595"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b67e480c3173a97258ff8159b64d82d8afcea4f21c4b2d4456b6e0d4b64f41a4" => :sierra
    sha256 "b21cea145fdb89a4af7658521df10c061e508ee5edfb6a8765766375423e0694" => :el_capitan
    sha256 "0fcdc27597c2eef4c982a5573701e6cf87684dea4549cfbf91e6d3ea98a0a812" => :yosemite
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install("bin/kops")
  end

  test do
    system "#{bin}/kops", "version"
  end
end
