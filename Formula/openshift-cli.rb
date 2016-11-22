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
    sha256 "50ea5520e6e5be0da389593e688ed51d6ae79c98a761a27da3dcb5bba0474776" => :sierra
    sha256 "39bd4835cdd527086ddbb67686cc746dab0d1f1647f9e10c3a599ac7d09c9e5f" => :el_capitan
    sha256 "92707527fa5d3d99c14d7efa550be0a72d315c6f93ce19ac03cc935fb283f176" => :yosemite
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.4.0-rc1",
      :revision => "b4e0954faa4a0d11d9c1a536b76ad4a8c0206b7c"
    version "1.4.0-rc1"

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
