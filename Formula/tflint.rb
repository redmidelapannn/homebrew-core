class Tflint < Formula
  desc "Linter for Terraform files"
  homepage "https://github.com/wata727/tflint"
  url "https://github.com/wata727/tflint.git",
    :tag      => "v0.11.2",
    :revision => "08afbfa51ed6cbd4bf6d41c43de8910515bb098b"
  head "https://github.com/wata727/tflint.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "374cef6773747d33f0c2344e852d8aa34efea13a5c296cfcb1b7e2a97f10cea0" => :mojave
    sha256 "d77a65e062c76512ae71c7c48ab9971f193c6293ff38589749a00b00da6579bb" => :high_sierra
    sha256 "ab01a3775ff0b0c62247939d3b75ee34b86f7436e15fd810b5a5a087538c6dce" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/wata727/tflint"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"tflint"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.tf").write <<~EOS
      provider "aws" {
        region = "${var.aws_region}"
      }
    EOS

    # tflint returns exitstatus: 0 (no issues), 2 (errors occured), 3 (no errors but issues found)
    assert_match "", shell_output("#{bin}/tflint test.tf")
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_match version.to_s, shell_output("#{bin}/tflint --version")
  end
end
