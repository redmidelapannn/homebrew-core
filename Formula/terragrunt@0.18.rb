class TerragruntAT018 < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.7.tar.gz"
  sha256 "1db9838f2f774599938eca25d7f8266da48693bcfd814292d083ad320f72c742"

  bottle do
    cellar :any_skip_relocation
    sha256 "eadfa2aa3f5333bfcc497363ef592de3887554faf49ae588fc1b00be73fbd9b5" => :mojave
    sha256 "218e059ba1792ebd3e2c3d344c70b2923534f49474c322121e43c60887df46da" => :high_sierra
    sha256 "58ca4bb4bb448e0e529bb2f566d663c147709a5cd20f89aa01a6ac63d090c8a3" => :sierra
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
