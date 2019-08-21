class TerragruntAT018 < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.7.tar.gz"
  sha256 "1db9838f2f774599938eca25d7f8266da48693bcfd814292d083ad320f72c742"
  bottle do
    cellar :any_skip_relocation
    sha256 "e4e2cf839c5cd7912fe3496c8a2e0d9b4213f10a4f264d1a85f24403fd66fc95" => :mojave
    sha256 "87c471b8d8b84c02bcc232ccd5f95a6a3b54b6bcd626b98284332f3abde8b3cb" => :high_sierra
    sha256 "3023e8c9920c2167d99ad70064d468e79ebda7e65173a5e09429cd1f6ce3799d" => :sierra
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
