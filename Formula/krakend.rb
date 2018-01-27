class Krakend < Formula
  desc "Ultra-High performance API Gateway built in Go"
  homepage "http://krakend.io"
  url "https://github.com/devopsfaith/krakend-ce/archive/0.4.0.tar.gz"
  sha256 "c0e48b0e8234b1d7975c3dfa953f3c7568e4f1583c5ffb3fef95ee236a902afd"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3b768681506b7488ddcf75a54f6e8f2960cfa2b8462dd29e592a0e79cac598a" => :high_sierra
    sha256 "52fae4ff408ef200c827c9fefa8799893a4f8ac2369e989c4c0210909845bf45" => :sierra
    sha256 "d87f8e5c4e4a17b78523810816ce8cb069589d7cf461d0952c7b37eab95ed50e" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "dep" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/devopsfaith/krakend-ce").install buildpath.children
    cd "src/github.com/devopsfaith/krakend-ce" do
      system "make", "deps"
      system "make", "build"
      bin.install "krakend"
    end
  end

  test do
    system "#{bin}/krakend", "--help"
  end
end
