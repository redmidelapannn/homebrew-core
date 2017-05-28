class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries."
  homepage "https://github.com/kshvmdn/fsql"
  url "https://github.com/kshvmdn/fsql/archive/v0.1.0.tar.gz"
  sha256 "7b27588e03127055b40f2a2ef4f554e86684bbdd1a4ef45cdad53f48ec9047e4"

  bottle do
    cellar :any_skip_relocation
    sha256 "74c57d0b8e57dd8a2750fc9c7f99589ccbcc928a7d954040c8fa782335d11829" => :sierra
    sha256 "817c23fb43bdbb8f39e6e3c727ffc959b54218913c923e5cb05e0d444a28be3f" => :el_capitan
    sha256 "6bcff93a8bb7ccf4515e7e992634e8185b30682cd9a10ccc468ef8b76eb2ae18" => :yosemite
  end

  depends_on "go" => :build

  def install
    mkdir_p buildpath/"src/github.com/kshvmdn"
    ln_s buildpath, buildpath/"src/github.com/kshvmdn/fsql"

    ENV["GOPATH"] = buildpath
    system "go", "build", "-o", "fsql"
    bin.install "fsql"
  end

  test do
    output = shell_output(bin/"fsql -version")
    assert_match "fsql v0.1.0", output
  end
end
