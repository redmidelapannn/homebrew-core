class Secreter < Formula
  desc "Kubernetes operator and CLI tool for encrypting Kubernetes secrets"
  homepage "https://github.com/amaizfinance/secreter"
  url "https://github.com/amaizfinance/secreter.git",
      :tag      => "v0.0.2",
      :revision => "e3e1c8f0c0e5d17a134786a96a1a2ca6cec8de84"
  head "https://github.com/amaizfinance/secreter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9fb82eb107ac4263d82d819665439b2606cbcaa7b8cba558d18597330efe61c2" => :mojave
    sha256 "775c9d9671ce684072c4bec5bb7eccbcb7501110fc76519e5fdbf96f72d4b490" => :high_sierra
    sha256 "c1fee1858b28028f6b70fb5e9d06c8cb8317243f99fa9149ce1e91333f03e021" => :sierra
  end

  depends_on "bazel" => :build

  def install
    ENV["DRONE_TAG"] = stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:tag] if build.stable?
    system "bazel", "build", "//cmd/cli:secreter"
    bin.install "bazel-bin/cmd/cli/darwin_amd64_pure_stripped/secreter"
  end

  test do
    system "#{bin}/secreter", "help"
    version_output = shell_output("#{bin}/secreter version --full 2>&1")
    assert_match stable.instance_variable_get(:@resource).instance_variable_get(:@specs)[:revision], version_output if build.stable?
  end
end
