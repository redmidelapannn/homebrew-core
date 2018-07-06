class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.8.2.tar.gz"
  sha256 "475cecc8cc12bddfe6d58311e3e084fb1583647b1902c8955d45adba1d22a273"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8e2e8bda31b68d288e2fd4c2df81b89dc41bf501a89a64ec75167c222822bbb" => :high_sierra
    sha256 "9bc5fcd60a47a3babe07a7137dfaa4f06f14c130cede5bcbd71f2f4b71eb544b" => :sierra
    sha256 "045986c07f7bb168973550286324da4f7ad376579b1a44a535f4de8f7b1fb592" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["PATH"] = ENV["PATH"] + ":" + buildpath + "/bin"

    dir = buildpath/"src/github.com/open-policy-agent/opa"
    dir.install Dir["*"]

    system "make", "deps", "-C", dir
    system "make", "-C", dir

    opa_bin = dir/"opa_darwin_amd64"
    mv opa_bin, dir/"opa"
    bin.install(dir/"opa")
  end

  test do
    system "echo", "pi = 3.14", "|", "#{bin}/opa", "eval", "--stdin"
  end
end
