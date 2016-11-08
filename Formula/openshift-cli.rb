class OpenshiftCli < Formula
  desc "OpenShift command-line interface tools"
  homepage "https://www.openshift.com/"
  url "https://github.com/openshift/origin.git",
    :tag => "v1.3.1",
    :revision => "274842360258d4f6ea1d3ec19559ecd395fd4d4f"

  head "https://github.com/openshift/origin.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f0a4bd10db1311182bc2a8f0f4fde1d52e23e140aac654634c5229183694121f" => :sierra
    sha256 "de220be349a7e6b2948e87803c1556efb89d94054a08e9c5baef5c4ae29b867f" => :el_capitan
    sha256 "83e77287d07eece3402a89901ebada657c1182725d58e5f3d7982795b4018988" => :yosemite
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.4.0-alpha.1",
      :revision => "f189ede42f58a45365a51c6eb781d86d5bdc4349"
    version "1.4.0-alpha.1"

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
    assert_match /^oc v#{version}/, shell_output("#{bin}/oc version")
    assert_match /^oadm v#{version}/, shell_output("#{bin}/oadm version")
  end
end
