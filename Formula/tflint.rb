class Tflint < Formula
  desc "Terraform linter that look for errors not detected by `terraform plan`"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint/archive/v0.5.3.tar.gz"
  sha256 "a46b32c4f67aa75d03e1b1a1f63d6134bdec87467f93cb551109a5db4a3f9429"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb0f35e1757098d846300a4a8d0405ead434222836e97b2755c03e7de207b812" => :high_sierra
    sha256 "c37b2f35caa93c39fea02c8ea40c087a41a7172001af4c3c30ea0c7f9b7e256f" => :sierra
    sha256 "3761b08a66347fb32915f4e6ec8ab37ee8324ed83aa646de421d16ed9d6e32e1" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home"
    (buildpath/"src/github.com/wata727/tflint").install buildpath.children
    cd "src/github.com/wata727/tflint" do
      system "glide", "install"
      system "go", "build", "-o", "tflint"

      bin.install "tflint"
    end
  end

  test do
    system "#{bin}/tflint", "--version"
  end
end
