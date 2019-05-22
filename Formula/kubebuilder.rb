class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.0.0-alpha.1",
      :revision => "a39cc1a586046d50a74455da6c44da734d2fb8fc"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4134d296178bbcbb6e67fe16ce6f772e324d1afcd5980008ab2ce138c58ff38b" => :mojave
    sha256 "0285613d30d0b6b1d30827cfb146bf3bd88289ed767109922e6e6ebd2a36215c" => :high_sierra
    sha256 "9dfa5a9e77e5d1a248e1c8d7f020a2e408dfc5ecc345c38280ec9cd0d1be6bc1" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/kubernetes-sigs/kubebuilder"
    dir.install buildpath.children

    cd dir do
      # Make binary
      system "make", "build"
      bin.install "bin/kubebuilder"
      prefix.install_metafiles
    end
  end

  test do
    ENV["GOPATH"] = testpath

    run_output = shell_output("#{bin}/kubebuilder --help 2>&1")
    assert_match "Development kit for building Kubernetes extensions and tools.", run_output
  end
end
