class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/terraform-linters/tflint/archive/v0.15.4.tar.gz"
  sha256 "3378055e8f1591c46d313765b4579d7484612ce88bea5222e5d0d14f4f8e5cef"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "986d4ee7a6873621b60a78077b76c9b5f441bec304d6951bc56d26786a6bb75d" => :catalina
    sha256 "9ff17206a14c313b7bc56ab9986e718ec5f593755830f0d47f54b37a37b71ffa" => :mojave
    sha256 "10c99eea91c2146853a428628095899ad04e55be48e2245f72a6ea0c0728820d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-o", bin/"tflint"
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = var.aws_region
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
