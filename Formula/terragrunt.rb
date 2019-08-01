class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.13.tar.gz"
  sha256 "cc1c2c0119ab6134f8c5d8d34ee9cfe65ceaa9382af64966801b8f5e78d641dd"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0bc29e63527c7387310af3bca6aae2daca130ebe0103c5c400bacdfdbd64428" => :mojave
    sha256 "f6dfd401f30b2b4a4bdb6e8f1bc9576f7e52ec57f2599b8221c5d528eb603d0a" => :high_sierra
    sha256 "4a273fb0f8992f146774ef0051848489fd8b0e37b0822f4a465f2d8d15215431" => :sierra
  end

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
