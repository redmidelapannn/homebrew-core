class Modelgen < Formula
  desc "Generate models from reading your database"
  homepage "https://github.com/LUSHDigital/modelgen"
  url "https://github.com/LUSHDigital/modelgen/archive/1.0.0.tar.gz"
  sha256 "31f15b7817054dff73df051e87ee27565cbd36dc839d3f2fde2516b2420573b5"

  bottle do
    cellar :any_skip_relocation
    sha256 "685ab70b24ca1c9cb065e452101ea7106af774d8006e53b4a1fde7c6b97045da" => :high_sierra
    sha256 "a5369597892369d4fcfc7e975bcce287336c7e2bbcfa0e01f7b345a091c4b217" => :sierra
    sha256 "003182f3c8a7fea74c81e444865467438c33e5b49fa1ba58d29e9d17a0f231da" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/LUSHDigital/modelgen").install buildpath.children
    cd "src/github.com/LUSHDigital/modelgen" do
      system "go", "build", "-ldflags", "-X main.version=#{version}"
      bin.install "modelgen"
    end
  end

  test do
    system "#{bin}/modelgen", "version"
  end
end
