class Minikube < Formula
  desc "Tool that makes it easy to run Kubernetes locally"
  homepage "https://kubernetes.io/docs/getting-started-guides/minikube/"
  url "https://github.com/kubernetes/minikube.git",
    :tag => "v0.26.1",
    :revision => "6ded2b647d1b1f62100c630bcfcc1363c631ce2d"

  bottle do
    cellar :any_skip_relocation
    sha256 "be03d3d9e722e367a274ba4e157a201973e49e797a5456fea10362d0ed200987" => :high_sierra
    sha256 "4d0bafb3fdf2c13988b6d2cc54053e9c060ada0d5b5ebc53ae427ebefc05e487" => :sierra
    sha256 "98c3a016b257cbd7d5af93dc2fb1027789dc07406e85458ea2c9ba84929d5d55" => :el_capitan
  end

  # Docker required for non-Linux builds
  depends_on "docker" => :build unless MacOS.version == Version::NULL

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    repo_path = buildpath/"src/k8s.io/minikube"
    repo_path.install Dir["*"]

    cd repo_path do
      system "make"
      bin.install "out/minikube" => "minikube"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minikube version 2>&1")
  end
end
