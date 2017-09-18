class Elvish < Formula
  desc "Friendly and Expressive Unix shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/0.10.tar.gz"
  sha256 "94585d0ff4c124b56609e3f2a0b97bb143289400d46d2d4d3c8871c1d90f0727"
  head "https://github.com/elves/elvish.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d7f656fcfbff2542c0013572a6ee9e9d50bfaafcc2aeaf671bb2a261fd7b60f5" => :sierra
    sha256 "9aef49ff2cdb5ca94fcbbaa6fcacdba9f2414341e1e76cf887cf8164f4e0615e" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/elves/elvish").install buildpath.children
    cd "src/github.com/elves/elvish" do
      system "go", "build", "-o", bin/"elvish"
      prefix.install_metafiles
    end
  end

  test do
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
