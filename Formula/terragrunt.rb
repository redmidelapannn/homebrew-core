class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.19.4.tar.gz"
  sha256 "c6b263d42ac7ec7fa4a0f15362dc2d93367a66597844bb9a1f1b52cfeb63c86e"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52175264c575bb1c2b7070c428fe2a3409aef69b47161086093141576cdaf53f" => :mojave
    sha256 "4841c12fcfdaca66f47f6b02e6cbb77b6a120817a09dd5801bdaad3df976dbbb" => :high_sierra
    sha256 "88155a1411c9eb635cd351f53421263701795fda56ea7b2653aca6e988668fce" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform" => :optional

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  def caveats
    <<~EOS
      Terraform dependency is marked as optional so it will not create conflicts
      with tfenv users. You can install the current Terraform version by issuing
      the following command:

        brew install terragrunt --with-terraform

      If you want to use specific Terraform version (which is recommended) you
      can use tfenv. 
      
      Without locking Terraform version (if you have more than one machine 
      running Terraform modules) you may have problems with state files which are
      always not backwards compatible.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
