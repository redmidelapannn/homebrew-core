class EnvkeySource < Formula
  desc "Set OS-level shell environment variables with EnvKey"
  homepage "https://www.envkey.com"
  url "https://github.com/envkey/envkey-source/archive/v1.2.9.tar.gz"
  sha256 "3f4684eea7e83ac5148a47a5f464e5c6930e1555cc4f8ace0cc807f18c15af7a"
  bottle do
    cellar :any_skip_relocation
    sha256 "57361c866bd7d4660dc85cdbf8c90d647c7ea119608e7c7fbb051e375792f9cd" => :mojave
    sha256 "04a95cce46f40fc7669729a220c8ce6b14010704cb81cfcb7d8a27e91bccff72" => :high_sierra
    sha256 "f5e3288915d376176de14cfdcc4d5e4e0481a3b6663adfd07874eaf8cde46429" => :sierra
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
