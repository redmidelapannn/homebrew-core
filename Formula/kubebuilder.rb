class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.3.0",
      :revision => "800f63a7e41a6a8016d4cb9d583e1705b0812c9d"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb32114809b8631d6b2ffddbef7578eed34e29d3a8bb0fbe3ea4690df695ee0d" => :catalina
    sha256 "b406f8a035a4d5524615c285a25c6ac4a08243f1ea8306474cd6f4a254dc10b0" => :mojave
    sha256 "b290bfd7da3148130846c3199d97dcbb8369beb13ba10373a609e725d345a491" => :high_sierra
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
