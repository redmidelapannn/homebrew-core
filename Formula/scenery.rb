class Scenery < Formula
  desc "Terraform plan output prettifier"
  homepage "https://github.com/dmlittle/scenery"
  url "https://github.com/dmlittle/scenery/archive/v0.1.1.tar.gz"
  sha256 "ae1c662ebe70c63baa3ddd8c0875fd2d132e3d0511619257c60369fd2ea18893"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c423ae3db081123d2c904a6bedc32a2c1a20bb27cafbfcc6571135bd2fc7ab1" => :mojave
    sha256 "966199caeffe4a6dcebffc7076c48f6be2084ae6aee3446741e86118be74e8d1" => :high_sierra
    sha256 "0f4d033b2b694b3d4bf276983c5409f84470dc06af418cf2800d134ab9b9096b" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"

    path = buildpath/"src/github.com/dmlittle/scenery"
    path.install Dir["{*,.git}"]

    cd path do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"scenery", "-ldflags", "-w -s -X main.Version=v#{version}"
      prefix.install_metafiles
    end
  end

  test do
    input = <<~EOS
      An execution plan has been generated and is shown below.
      Resource actions are indicated with the following symbols:
        + create

      Terraform will perform the following actions:

      + module.module_name
        id: <computed>

      Plan: 3 to add, 0 to change, 0 to destroy.

      ------------------------------------------------------------------------
    EOS

    expected_output = <<~EOS
      + module.module_name
          id: <computed>

      Plan: 3 to add, 0 to change, 0 to destroy.
    EOS

    output = shell_output("echo '#{input}' | #{bin}/scenery")
    assert_match expected_output, output
  end
end
