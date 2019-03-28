class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/weaveworks/flux"
  url "https://github.com/weaveworks/flux.git",
      :tag      => "1.11.0",
      :revision => "fde27d142064dac30c2f548f03ae2ca63749d5f6"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8607a8c5d7b1088e3521eedbd79e9fb61b8d6bb6513747a3aaa740a0d12a762" => :mojave
    sha256 "8053031275cb4de6cd98e9b962e775b6b9e9da1179178bf6f8bf6ab41f07fd19" => :high_sierra
    sha256 "a706731c41eca293e9b9fdacae57bcb8949580a6afd0de17275d2646013e762a" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/weaveworks/flux"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "release-bins"
      bin.install "build/fluxctl_darwin_amd64" => "fluxctl"
      prefix.install_metafiles
    end
  end

  test do
    run_output = shell_output("#{bin}/fluxctl 2>&1")
    assert_match "fluxctl helps you deploy your code.", run_output

    version_output = shell_output("#{bin}/fluxctl version 2>&1")
    assert_match version.to_s, version_output
  end
end
