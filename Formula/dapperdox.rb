class Dapperdox < Formula
  desc "Beautiful, integrated, OpenAPI documentation"
  homepage "http://dapperdox.io"
  url "https://github.com/DapperDox/dapperdox/archive/v1.1.1.tar.gz"
  sha256 "fa207e27929c2a65a81ad241bb51471835c90236ed7720db16de622d9e9379d7"

  bottle do
    cellar :any_skip_relocation
    sha256 "25d3f456923a6fec61f1754dce03b0ddac170507a277527a47a6ca9d29e701d9" => :sierra
    sha256 "11cada42eb5d075d3af6703eb10b6c4f3f9cd09b16bcb20b4648e41139932969" => :el_capitan
    sha256 "51dec35c6092cca33e69a03966dc2aebd65f2c3913a7fa45848adb3d01dfdfba" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/DapperDox/dapperdox").install buildpath.children

    cd "src/github.com/DapperDox/dapperdox" do
      system "go", "get"
      system "go", "build", "-o", bin/"dapperdox"
      prefix.install_metafiles
      (pkgshare/"examples").install Dir["examples/*"]
    end
  end

  test do
    assert (bin/"dapperdox").exist?
  end
end
