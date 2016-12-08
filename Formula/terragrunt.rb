class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state."
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.6.0.tar.gz"
  sha256 "1a2cb59b1954dc53807a24db1f79f50d4a5fec4d2b3c115fad5b4413c24cf141"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2499b93b60460c973e37a68cdd2cdd7238f3ecac53f74f10f10e027d9829a336" => :sierra
    sha256 "9e145c0da604cfd924e81a69b71d310945128f70c8a5e3354ac3d078f63278fd" => :el_capitan
    sha256 "ed755258ba90775a48a4847ac24e827b7c60907f4e389b739754cf5c6d57619d" => :yosemite
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
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=" + version.to_s
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
