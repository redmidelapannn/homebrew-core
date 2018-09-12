class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/0.0.1.tar.gz"
  sha256 "13789368b1379aa2ad52bce5b855b56ca88f684ed0dff42adf107ee9738187b0"
  bottle do
    cellar :any_skip_relocation
    sha256 "a415da6b8aff64bfc22c48a0a6a0a8c447dd0a457992424d5462050c0de3f632" => :mojave
    sha256 "35574967867abd985d0eafa43e5bec8c5fc193c99c1083e5bf503e75d088417f" => :high_sierra
    sha256 "88c7b9db76459869951f34ea091cf3db409d5a4a3d3a79869e9caa1b4f970623" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/smimesign").install buildpath.children
    cd "src/github.com/github/smimesign" do
      system "go", "build"
      bin.install "smimesign"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/smimesign", "-h"
  end
end
