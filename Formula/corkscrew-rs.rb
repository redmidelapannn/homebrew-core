class CorkscrewRs < Formula
  desc "The quick and dirty port of corkscrew in rust"
  homepage "https://github.com/rustch/corkscrew-rs"
  url "https://github.com/rustch/corkscrew-rs/releases/download/0.1.0/corkscrew-rs.apple_x86_64.tar.bz2"
  version "0.1.0"
  sha256 "47ad58bf7dc4e521223865b6db83f0de77be2dcc0ffc2801a1e0273edc31085e"
  bottle do
    cellar :any_skip_relocation
    sha256 "321a0ad8e2b12d09b20612184279ed00ba228733d4bb6620227498d839f169a6" => :mojave
    sha256 "2b757d80ab39d77a2e1ffc05ebb6eb8a48666b4dbd4d863e590560b7f551ddc4" => :high_sierra
    sha256 "2b757d80ab39d77a2e1ffc05ebb6eb8a48666b4dbd4d863e590560b7f551ddc4" => :sierra
    sha256 "2b757d80ab39d77a2e1ffc05ebb6eb8a48666b4dbd4d863e590560b7f551ddc4" => :el_capitan
  end

  def install
    bin.install "corkscrew-rs"
  end
  test do
    stdin.write("#{bin}/corkscrew-rs")
    stdin.close
    assert_true stdin.read.start_with? "corkscrew-rs #{version}"
  end
end
