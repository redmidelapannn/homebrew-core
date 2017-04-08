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
    sha256 "111f4903b0f2800c399ea9e8c6040d8111efa1ecea1d1e371aa314bf0861092a" => :sierra
    sha256 "7ede67a7c306bc50cd08a16b08113fc889804e051afb308cdff96c1e6190d95c" => :el_capitan
    sha256 "db9c9ddc17f0195f42667f6a6bf3bbec1e94db6e12a5511b647a2ed8581340be" => :yosemite
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
