class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://github.com/kubernetes/kops"
  url "https://github.com/kubernetes/kops/archive/1.7.1.tar.gz"
  sha256 "044c5c7a737ed3acf53517e64bb27d3da8f7517d2914df89efeeaf84bc8a722a"
  head "https://github.com/kubernetes/kops.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5388d9e571083838af42a175586a33c59ef578aef77b7d50e91faadc6df83e3f" => :high_sierra
    sha256 "786de1645750ef6cd3baa48a87811b6b70ef22aae38ad406d0022aa1f2da281a" => :sierra
    sha256 "3ee91cf797a42d2c18cd3ef2a340a3158104127d45705d21dedb500cf6d00114" => :el_capitan
  end

  devel do
    url "https://github.com/kubernetes/kops/archive/1.8.0-beta.1.tar.gz"
    sha256 "81026d6c1cd7b3898a88275538a7842b4bd8387775937e0528ccb7b83948abf1"
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
