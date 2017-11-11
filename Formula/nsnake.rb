class Nsnake < Formula
  desc "Classic snake game with textual interface"
  homepage "https://github.com/alexdantas/nSnake"
  url "https://downloads.sourceforge.net/project/nsnake/GNU-Linux/nsnake-3.0.1.tar.gz"
  sha256 "e0a39e0e188a6a8502cb9fc05de3fa83dd4d61072c5b93a182136d1bccd39bb9"
  head "https://github.com/alexdantas/nSnake.git"

  bottle do
    rebuild 1
    sha256 "73cda71920d9902dc0e88b8cce3099d91ae850d7860a97400f5397987160d952" => :high_sierra
    sha256 "dbc22643cf88d4f433c4f0aa0ff0086344e2fa41fb44ec09661ff39ede4c859e" => :sierra
    sha256 "9e2e0a9b9a13647f584acc8496d282c68ed67e091874502a232324f2712771dc" => :el_capitan
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"

    # No need for Linux desktop
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"pixmaps").rmtree
  end

  test do
    assert_match /nsnake v#{version} /, shell_output("#{bin}/nsnake -v")
  end
end
