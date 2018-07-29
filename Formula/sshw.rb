class Sshw < Formula
  desc "🐝  ssh client wrapper for automatic login"
  homepage "https://github.com/yinheli/sshw"
  url "https://github.com/yinheli/sshw/archive/v1.0.4.tar.gz"
  sha256 "7b48c8126f4fca50c186f864c5e9db1578d7670e2b9b0887922d5a2c56051a71"

  bottle do
    cellar :any_skip_relocation
    sha256 "32f7655c539287d256adf7096fd498988f5caef6066a25fb3e52c6ff1cad8091" => :high_sierra
    sha256 "5844af60527c90659f94c410f7a72656502cd3585a0fdc8948ed5a3469710ab5" => :sierra
    sha256 "db647aa7d540a34442aa9b905cbf8095803335e45b2c0793fac410d8595b0e2f" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["SSHW_GIT_TAG"] = "v1.0.4"
    ENV["SSHW_GIT_HASH"] = "6c5d46dc"
    (buildpath/"src/github.com/yinheli/sshw").install buildpath.children

    cd "src/github.com/yinheli/sshw" do
      system "make", "sshw"
      bin.install "release/sshw"
    end
  end

  test do
    system "#{bin}/sshw", "-version"
  end
end
