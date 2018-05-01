class Dep < Formula
  desc "Go dependency management tool"
  homepage "https://github.com/golang/dep"
  url "https://github.com/golang/dep.git",
      :tag => "v0.4.1",
      :revision => "37d9ea0ac16f0e0a05afc3b60e1ac8c364b6c329"
  revision 1
  head "https://github.com/golang/dep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "39dc339ed5fc052f27f277602ac495630ec5e356b1da0d8e1f11d7f213c7b881" => :high_sierra
    sha256 "5474e2976b94072d2cb8ef78bda3c29a837f0619c92dec9f7475e186a9d138ea" => :sierra
    sha256 "6fdc76ca548545403b28af6d10fa5be48a91dd0d6433834a7e92815ac2f2462c" => :el_capitan
  end

  depends_on "go"

  conflicts_with "deployer", :because => "both install `dep` binaries"

  def install
    ENV["GOPATH"] = buildpath
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    (buildpath/"src/github.com/golang/dep").install buildpath.children
    cd "src/github.com/golang/dep" do
      ENV["DEP_BUILD_PLATFORMS"] = "darwin"
      ENV["DEP_BUILD_ARCHS"] = arch
      system "hack/build-all.bash"
      bin.install "release/dep-darwin-#{arch}" => "dep"
      prefix.install_metafiles
    end
  end

  test do
    # Default HOMEBREW_TEMP is /tmp, which is actually a symlink to /private/tmp.
    # `dep` bails without `.realpath` as it expects $GOPATH to be a "real" path.
    ENV["GOPATH"] = testpath.realpath
    project = testpath/"src/github.com/project/testing"
    (project/"hello.go").write <<~EOS
      package main

      import "fmt"
      import "github.com/Masterminds/vcs"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    cd project do
      system bin/"dep", "init"
      assert_predicate project/"vendor", :exist?, "Failed to init!"
      inreplace "Gopkg.toml", /(version = ).*/, "\\1\"=1.11.0\""
      system bin/"dep", "ensure"
      assert_match "795e20f90", (project/"Gopkg.lock").read
      output = shell_output("#{bin}/dep status")
      assert_match %r{github.com/Masterminds/vcs\s+1.11.0\s}, output
    end
  end
end
