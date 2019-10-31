class EnvkeySource < Formula
  desc "Set OS-level shell environment variables with EnvKey"
  homepage "https://www.envkey.com"
  url "https://github.com/envkey/envkey-source/archive/v1.2.9.tar.gz"
  sha256 "3f4684eea7e83ac5148a47a5f464e5c6930e1555cc4f8ace0cc807f18c15af7a"
  bottle do
    cellar :any_skip_relocation
    sha256 "4720efe3468dc4d89ab8e1211a82475d8c216aa5a121704a18a0f3f3fa995247" => :catalina
    sha256 "cbd9a36a9cfafe338274ed5435eb503cec960207845849e67a2148eb414f5395" => :mojave
    sha256 "ba502261088ba3eee607e65894dcb4eedec22fb60d1f9421a0be4145575e830c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath/"src"
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "envkey-source", "main.go"

    bin.install "envkey-source"
  end

  test do
    output = shell_output("#{bin}/envkey-source").chomp
    assert_match "echo 'error: ENVKEY missing.'; false", output
  end
end
