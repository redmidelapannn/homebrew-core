class Prest < Formula
  desc "Serve a RESTful API from any PostgreSQL database"
  homepage "https://github.com/prest/prest"
  url "https://github.com/prest/prest/archive/v0.3.1.tar.gz"
  sha256 "93a16764093b5f7c2d708d125d3937cf9d4c9bead7c83da7f01ba958116e85c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "a9b33cca6881b668f944dee7db88c99faca4921cc763d6a0142462cb4f964b0c" => :high_sierra
    sha256 "b4853d826cd57cee31e107ff7510f5cbb31100aa15e97eb913a9c3e58d08e090" => :sierra
    sha256 "1d8756042540d87582f0a5f3cf4ef2c0dc6443db4250951f432e430f5ba6509c" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/prest/prest").install buildpath.children
    cd "src/github.com/prest/prest" do
      system "go", "build", "-o", bin/"prest"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/prest", "version"
  end
end
