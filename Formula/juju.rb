class Juju < Formula
  desc "DevOps management tool"
  homepage "https://jujucharms.com/"
  url "https://launchpad.net/juju/2.6/2.6.10/+download/juju-core_2.6.10.tar.gz"
  sha256 "d781b733dd7a4e74ef0e9f88527a74a4bea0298e56f4dcaa6dd1cf62c2c40f2b"

  bottle do
    cellar :any_skip_relocation
    sha256 "af6f70baa692b7d95522d6364b6dcde6d5ba89fd1da0432986c46b4836f78b26" => :catalina
    sha256 "2f3a8569978cbafc157cdf8992d81b86cdeddfbcda0a64270d5c3d5ce569f790" => :mojave
    sha256 "c31e0b334bf9b685fd9c74b12c0fd78519d72cc0c7828ea39ccdd27304ccec5e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
