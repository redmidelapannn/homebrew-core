class TerragruntAT018 < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.7.tar.gz"
  sha256 "1db9838f2f774599938eca25d7f8266da48693bcfd814292d083ad320f72c742"

  bottle do
    cellar :any_skip_relocation
    sha256 "e433089d0af32fd3d68f09cf814d26ee2c12a411d4c75df94623fe72a62d6b9a" => :mojave
    sha256 "dcd32a820a451d8511edb797e8f957278148f2514bb9eaa9e42ed2ef94ea11e5" => :high_sierra
    sha256 "900e64658ae80f0728e7fc5a7b0d3b5a7435298b6d1921abbd90194ab983d143" => :sierra
  end

  keg_only :versioned_formula
  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
