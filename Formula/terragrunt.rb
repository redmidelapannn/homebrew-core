class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt.git",
    :tag      => "v0.21.0",
    :revision => "84e77303a8c1ce634522612a19f0c12e1ce20a4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "f000324e2dfbadad277fc0cf9d532f594c66690e69d3fb7c794b89b0a075dba8" => :catalina
    sha256 "068b12acb36d6479b4ba787b4346d8b3b9dfae66a8b7aaeab61b497256a2351b" => :mojave
    sha256 "dbc37363e1c79b967153cbfcfe199b1913c7593124ff3a1fe93c71fe75f23352" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  # should be removed > v0.21.0
  patch do
    url "https://github.com/gruntwork-io/terragrunt/pull/928.patch?full_index=1"
    sha256 "21137277f7c7ded4eb2c1854cd880e7744329e735066f2f2b2f453271f3138b1"
  end

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
