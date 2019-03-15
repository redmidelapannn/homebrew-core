class Atlantis < Formula
  desc "Terraform For Teams"
  homepage "https://www.runatlantis.io"
  url "https://github.com/runatlantis/atlantis/archive/v0.5.1.tar.gz"
  sha256 "4c0615e4979c9bda4343043056667bd14dcb3dc829e4bfd37ed04e00edb71fbb"
  head "https://github.com/runatlantis/atlantis.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "578437241c197a1936791db2778b2c72032e07d8039d196b2ddd42d09be27893" => :mojave
    sha256 "5adfb40dfc884efd2f0bc480a28961d915451a963d714482775dc41d27231102" => :high_sierra
    sha256 "73bef0cf71e6b37805324d2b4830253ce0125aef2cff7564a0683b1e59d970fc" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/runatlantis/atlantis").install buildpath.children

    cd "src/github.com/runatlantis/atlantis" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"atlantis", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/atlantis version")
  end
end
