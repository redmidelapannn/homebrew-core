class Kubebuilder < Formula
  desc "SDK for building Kubernetes APIs using CRDs"
  homepage "https://github.com/kubernetes-sigs/kubebuilder"
  url "https://github.com/kubernetes-sigs/kubebuilder.git",
      :tag      => "v2.0.0",
      :revision => "b31cc5d96dbc91749eb49c2cf600bd951a46d4bd"
  head "https://github.com/kubernetes-sigs/kubebuilder.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e8a15070bbbdc744e202b6ae29b6471793bb52031a525ef4fc08efd2f2551a00" => :mojave
    sha256 "ebe8758f025e3b1da77243552c54288e12ce1144990c4adb0a7c3156c63da25c" => :high_sierra
    sha256 "dfeecf9ffe85351ccc49186b2a53f3434e8febe2cfa77570e1a36752134f46d6" => :sierra
  end

  depends_on "git-lfs" => :build
  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/sigs.k8s.io/kubebuilder"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      # Make binary
      system "make", "build"
      bin.install "bin/kubebuilder"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/kubebuilder", "init",
      "--repo=github.com/example/example-repo", "--domain=example.com",
      "--license=apache2", "--owner='The Example authors'", "--fetch-deps=false"
  end
end
