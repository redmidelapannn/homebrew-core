class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.2.1",
    :revision => "5e723f67f1e36d387a8a7faa6aa8a7f40cc9ca46"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "f9ec2424814c9f267d848988500d0e2348bb8d9b0228b95ed8a91a40b687ec9c" => :el_capitan
    sha256 "bf14a4f73f2315040443dee491021a3a945a8423a7d68270b41355b3c5411233" => :yosemite
    sha256 "ff9b2e96e5f7abdccc76273490eac450f6458ff50e6571c416138ad2be0e93aa" => :mavericks
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.3.0-rc1",
      :revision => "884520c98e75d0f96e679959b28caf17f0e7fa29"
    version "1.3.0-rc1"

    depends_on "socat"
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
    assert_match /^oc v#{version}$/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}$/, shell_output("#{bin}/oadm version")
  end
end
