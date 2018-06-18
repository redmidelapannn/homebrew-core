class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.11.tar.gz"
  sha256 "711f67d8730990deed00c3e0c59198c8a51c8441371416faab5ef603c26010b6"
  head "https://github.com/elves/elvish.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5fd49fb24b4376840922a3cd43c4dceab2a32efd483a436929a7f0e1f78f3ed8" => :high_sierra
    sha256 "ba8e8c4a5c400d3852fd4d2b7f36baf50b4dd6a276ee3619d1842ee948ca5f4b" => :sierra
    sha256 "9e018f85f372173e92d90c048d866e68bb7a20821966e5bfb2e1324d15edd62a" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    version = `git describe --tags --always`.strip
    goroot = `go env GOROOT`.strip
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-ldflags",
             "-X github.com/elves/elvish/buildinfo.Version=#{version} -X github.com/elves/elvish/buildinfo.GoPath=#{buildpath} -X github.com/elves/elvish/buildinfo.GoRoot=#{goroot}", "-o",
             bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
