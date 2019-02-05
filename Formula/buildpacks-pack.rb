class BuildpacksPack < Formula
  desc "CLI tool for building applications with Cloud Native Buildpacks"
  homepage "https://buildpacks.io"
  url "https://github.com/buildpack/pack/archive/v0.0.9.tar.gz"
  sha256 "b25028e738ef14cb1df108b8cf12a2302a4a2ec9d88c03c3ccf0638a8fef1994"

  bottle do
    cellar :any_skip_relocation
    sha256 "0a7e62259131fa88ecd2f4d064bc44f1e42a4f0d20a01cd9e365d95c0c4d7edd" => :mojave
    sha256 "d0958c7ecfcb47ccbd67479fdfcbd072b4b7c4a07823d298fe1ee9f499426d5a" => :high_sierra
    sha256 "07b3765b4549fe55424e9f2ac9fa2753da1b94575294a5591479cc57e0c7b4da" => :sierra
  end

  depends_on "go" => :build

  def install
    ldflags = ["\"-X main.Version=#{version}\""]
    system "go", "build", "-o", "pack", "-ldflags", ldflags, "./cmd/pack"
    bin.install "pack"
    prefix.install_metafiles
  end

  test do
    testdata = <<~TOML
      [buildpack]
      id = "sh.brew.buildpack.test"
      version = "0.0.1"
      name = "Test buildpack for Homebrew formula"

      [[stacks]]
      id = ["io.buildpacks.stacks.bionic"]
    TOML
    (testpath/"buildpack.toml").write testdata
    output = shell_output("#{bin}/pack version")
    assert_match /0.0.9/, output
  end
end
