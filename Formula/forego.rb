class Forego < Formula
  desc "Foreman in Go"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/d42165a186c1e4bdc772b9fa4dff9506e9294537.tar.gz"
  sha256 "1c9f0fd89700271eb208dc9ed14e3480d70fd6b81df16810585e90011f3d1697"

  head "https://github.com/ddollar/forego.git"

  bottle do
    sha256 "271f00d20db7f1ba6b4f48be8e595adf04ce79e39c43dae5efd3c028962a7d21" => :sierra
    sha256 "b062c3b1eab2938ccadd42f10695726475a41417ae7cae00e889eae332669fd0" => :el_capitan
    sha256 "e3497b1c718f31b690d9ce66fae637d1c389c1ef55d74b1a6aaef4e8fad00cbe" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p buildpath/"src/github.com/ddollar/"
    ln_sf buildpath, buildpath/"src/github.com/ddollar/forego"

    ldflags = "-X main.Version=#{version} -X main.allowUpdate=false"
    system "go", "build", "-ldflags", ldflags, "-o", bin/"forego", "-v", "github.com/ddollar/forego/"
  end

  test do
    (testpath/"Procfile").write "web: echo \"it works!\""
    assert_match "it works", shell_output("#{bin}/forego start")
  end
end
