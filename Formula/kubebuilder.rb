class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.3.1",
      :revision => "8b53abeb4280186e494b726edf8f54ca7aa64a49"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0dba78ce1b4aff1fc50a0302ea7905c7f70b929bf2d54c8a13a6e4ebf8301ed" => :catalina
    sha256 "d6d9d6714fdddfd32f95d9f3f10d664a8a44e791927a262194d39ec6aab39da7" => :mojave
    sha256 "ad31d8bb2aec396a87e94ddfed548b0ee239f4f18ec2dd0b25e7d23d975bc9f4" => :high_sierra
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    system "make", "build"
    bin.install "bin/kubebuilder"
    prefix.install_metafiles
  end

  test do
    system "#{bin}/kubebuilder", "init",
      "--repo=github.com/example/example-repo", "--domain=example.com",
      "--license=apache2", "--owner='The Example authors'", "--fetch-deps=false"
  end
end
