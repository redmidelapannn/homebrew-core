class TerragruntAT018 < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.7.tar.gz"
  sha256 "1db9838f2f774599938eca25d7f8266da48693bcfd814292d083ad320f72c742"

  bottle do
    cellar :any_skip_relocation
    sha256 "b29e4c39cec23cb352c776888f2a16ad0bad4ae1dd8a1dda6625835b6ad459d0" => :mojave
    sha256 "da90fd60bc6147df57b4d02a3e5fdcddce5ca18066a131fb48ce64b682cf627e" => :high_sierra
    sha256 "bf00e35bca55fc0bfc7acf2a600f188e663206a3fcbf04298edbf15bfaaa2c3d" => :sierra
  end

  keg_only :versioned_formula

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform@0.11"

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
