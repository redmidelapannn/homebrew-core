class Godep < Formula
  desc "Dependency tool for go"
  homepage "https://godoc.org/github.com/tools/godep"
  url "https://github.com/tools/godep/archive/v79.tar.gz"
  sha256 "3dd2e6c4863077762498af98fa0c8dc5fedffbca6a5c0c4bb42b452c8268383d"
  revision 3

  head "https://github.com/tools/godep.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "533cbfcbbe27bfe0dbccf41a96e6395b92cd46741631b02fcf211827bdf16089" => :sierra
    sha256 "f1c472efef27d6c4ae3241f7bd7b91e4bc15c7d929f8fff8bbd7d812f5c1c968" => :el_capitan
    sha256 "99d2b6ed8a7ae75963ed1489b97c01d89fc6d08d9d093465f0acbfa2f8b80e26" => :yosemite
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tools/godep").install buildpath.children
    cd("src/github.com/tools/godep") { system "go", "build", "-o", bin/"godep" }
  end

  test do
    ENV["GOPATH"] = testpath.realpath
    (testpath/"Godeps/Godeps.json").write <<-EOS.undent
      {
        "ImportPath": "github.com/tools/godep",
        "GoVersion": "go1.8",
        "Deps": [
          {
            "ImportPath": "golang.org/x/tools/cover",
            "Rev": "3fe2afc9e626f32e91aff6eddb78b14743446865"
          }
        ]
      }
    EOS
    system bin/"godep", "restore"
    assert_predicate testpath/"src/golang.org/x/tools/README", :exist?,
                     "Failed to find 'src/golang.org/x/tools/README!' file"
  end
end
