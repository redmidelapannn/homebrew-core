class Compose2kube < Formula
  desc "Convert docker-compose service files to Kubernetes objects."
  homepage "https://github.com/kelseyhightower/compose2kube"
  url "https://github.com/kelseyhightower/compose2kube/archive/0.0.2.tar.gz"
  sha256 "d09b86994949f883c5aa4d041a12f6c5a8989f3755a2fb49a2abac2ad5380c30"
  head "https://github.com/kelseyhightower/compose2kube.git"

  bottle do
    sha256 "4d60bd5a5edc0aaca32bda3fcdb1925e0a52f2f233dcb35bd6d160cdf60255d0" => :sierra
    sha256 "931a8e9e44b1e67d9cf2ee9e26fa13e6886cd6190fc334d6b68045c75faf3156" => :el_capitan
    sha256 "1061e96c1e57cd917a370fbf5b48f5286bfdc967755d84a996350e7a2e07120a" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/kelseyhightower/compose2kube").install buildpath.children
    cd "src/github.com/kelseyhightower/compose2kube" do
      system "go", "build", "-o", bin/"compose2kube"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/compose2kube -h 2>&1", 2)
  end
end
