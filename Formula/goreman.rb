class Goreman < Formula
  desc "Foreman clone written in Go"
  homepage "https://github.com/mattn/goreman"
  url "https://github.com/mattn/goreman/archive/v0.2.1.tar.gz"
  sha256 "c1ef360fcc92688956bc7a18fae089d78754bd1dde22a89b27228ae5a840cc45"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0e12e04e84b47f8899817f2f828875c67a283588b34b62a66a43f8b88e9579c2" => :mojave
    sha256 "eba12ae4e6a5e0f0c573d1cfff95a3cf3ae788daa6dace003e45cdfab20d7815" => :high_sierra
    sha256 "133783990df19048c41c80108ebc003ecce6ada23fa574dda70911732418587a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    srcpath = buildpath/"src/github.com/mattn/goreman"
    srcpath.install buildpath.children

    cd srcpath do
      system "go", "build", "-o", bin/"goreman"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"Procfile").write "web: echo 'hello' > goreman-homebrew-test.out"
    system bin/"goreman", "start"
    assert_predicate testpath/"goreman-homebrew-test.out", :exist?
    assert_match "hello", (testpath/"goreman-homebrew-test.out").read
  end
end
