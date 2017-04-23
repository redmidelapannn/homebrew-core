class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.12.4.tar.gz"
  sha256 "907f9d9fba37ab5e13b38d42ba324c66e1d8db8fe138b9164a0c3d26e034225b"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9a932437b9d174a38fb9e538611476a4c8d26c2bfd79707e08b497158dcd26ec" => :sierra
    sha256 "b8fcb2dbab75e8103955963e687919a98aab8cea0d7a6abb05e906debc9bb550" => :el_capitan
    sha256 "83a5606ef60fff982361e32f776a71694afffde9d392f34c3e853e3fd076e982" => :yosemite
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/gruntwork-io/"
    ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
    system "glide", "install"
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
