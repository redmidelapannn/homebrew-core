class GoStatik < Formula
  desc "Embed files into a Go executable"
  homepage "https://github.com/rakyll/statik"
  url "https://github.com/rakyll/statik/archive/v0.1.6.tar.gz"
  sha256 "f157a1ada813eb643ddd9a60a0efe3158f1da25b1d11bc1ef6c7fa219d4b23bf"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52c2806cfedb87fbfeff0329853d707ee1488eae7f572b1d9ba4322c9a5f84aa" => :catalina
    sha256 "b41d39457f5f6cd30cfe77baee84728120af63668a66bd4cb543c2eee5ea5c03" => :mojave
    sha256 "873610e345e126bc88b2807df25ea8d9e1ea3391761643a2c51696f97c68884f" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "statik", :because => "both install `statik` binaries"

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"
    (buildpath/"src/github.com/rakyll/statik").install buildpath.children

    cd "src/github.com/rakyll/statik" do
      system "go", "build", "-o", bin/"statik"
      prefix.install_metafiles
    end
  end

  test do
    font_name = (MacOS.version >= :catalina) ? "Arial Unicode.ttf" : "Arial.ttf"
    system bin/"statik", "-src", "/Library/Fonts/#{font_name}"
    assert_predicate testpath/"statik/statik.go", :exist?
    refute_predicate (testpath/"statik/statik.go").size, :zero?
  end
end
