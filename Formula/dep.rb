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
    sha256 "07344d28542fa798219be47eee3393eac45c0ecb74f42d249ac32896e48f7aae" => :high_sierra
    sha256 "0e10612cbd15b93536da050ffa8ddf13ce97e59669ab24e787319bf313aa3a11" => :sierra
    sha256 "cd2d87c105543b8cfd875086e45365e436ee4875c81330687ab8077edfa98260" => :el_capitan
  end

  depends_on "go" => :build

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
