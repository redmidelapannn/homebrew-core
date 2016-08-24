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
    sha256 "8d566e13dcf175d17998be25d0e41dc3c9a9bebb92b104b5c59fd65d583f2e14" => :el_capitan
    sha256 "b6ab7b5bd3765b2874eb2b8f7e7569ae29f9a92bfd5ab1d43da80535d1747ba2" => :yosemite
    sha256 "240d559d49db87f8db81e70d144e6034acd9f72f3c2dcf457a5dcf61d1f67d65" => :mavericks
  end

  devel do
    url "https://github.com/openshift/origin.git",
      :tag => "v1.3.0-alpha.3",
      :revision => "7998ae49782d89d17c78104d07a98d2aea704ae3"
    version "1.3.0-alpha.3"
    
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
