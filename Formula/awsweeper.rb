class Awsweeper < Formula
  desc "Cleat out your AWS account with this convenient tool"
  homepage "https://github.com/cloudetc"
  url "https://github.com/cloudetc/awsweeper/archive/v0.2.0.tar.gz"
  sha256 "e867ecc3df01fb799fe900bc587676460ade1752f63c9176542bb66d27a1833a"

  bottle do
    cellar :any_skip_relocation
    sha256 "1fcf668dd4de7e0b25901a90c297746d7d14b9dfdbaf9dcd1f62486f7f0ba3f7" => :mojave
    sha256 "0961aa160e0ef538f8ce0523ac3ac09f9d90c68433eba689982983d2c0270ee0" => :high_sierra
    sha256 "d85872d1c9bac0090cb3a788eb6e6d2767e1923b556f92f91bc3911dda23051e" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    awsweeper_path = buildpath/"src/github.com/cloudetc/awsweeper"
    awsweeper_path.install buildpath.children

    cd awsweeper_path do
      system "go", "build"
      bin.install "awsweeper"
    end
  end

  test do
    assert_match "0.1.1", shell_output("#{bin}/awsweeper --version ")
  end
end
