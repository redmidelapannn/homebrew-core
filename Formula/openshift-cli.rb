class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.3.2",
    :revision => "ac1d57910e550a090541ea0140566ff3240777b3"

  head "https://github.com/openshift/origin.git"

  depends_on "socat"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b84052787cbd88726d1ab1edf6816ca3a6add7f5a1d9513e9704fa44ff004d00" => :sierra
    sha256 "0c30158c408f7f5830dc1539e7fd25f1a89e054e4405cb5b2b4cf3f1cb195e50" => :el_capitan
    sha256 "a52a67769837a5aa710227f5845ef5673cab7f5a4572d1d3e9d834b0216e518d" => :yosemite
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.4.0-rc1",
      :revision => "b4e0954faa4a0d11d9c1a536b76ad4a8c0206b7c"
    version "1.4.0-rc1"
  end

  depends_on "go" => :build

  def install
    # this is necessary to avoid having the version marked as dirty
    (buildpath/".git/info/exclude").atomic_write "/.brew_home"

    system "make", "all", "WHAT=cmd/oc", "GOFLAGS=-v", "OS_OUTPUT_GOPATH=1"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/oc"
    bin.install_symlink "oc" => "oadm"

    bash_completion.install Dir["contrib/completions/bash/*"]
  end

  test do
    assert_match /^oc v#{version}/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}/, shell_output("#{bin}/oadm version")
  end
end
