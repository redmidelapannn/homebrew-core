class ReattachToUserNamespace < Formula
  desc "Reattach process (e.g., tmux) to background"
  homepage "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard"
  url "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard/archive/v2.5.tar.gz"
  sha256 "26f87979a4a2cf81ca4ff9e1e097e7132babf2ff2ef5eb03ebfc3b510345a147"

  head "https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f139d31960835121e84a8d4b62bf232b133a1a5bf3a2408316fc5db3f06d225f" => :sierra
    sha256 "28bcb892f329ade7efcd7842cfee84f20f80181f86132a722f071f4d40fd4852" => :el_capitan
    sha256 "f3e6ea3c164d6789dbb4ac652395b2d80df28956e170f289df02b317ef55a9cf" => :yosemite
  end

  def install
    system "make"
    bin.install "reattach-to-user-namespace"
  end

  test do
    system bin/"reattach-to-user-namespace", "-l", "bash", "-c", "echo Hello World!"
  end
end
