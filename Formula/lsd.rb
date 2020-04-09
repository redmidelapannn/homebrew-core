class Lsd < Formula
  desc "Clone of ls with colorful output, file type icons, and more"
  homepage "https://github.com/Peltoche/lsd"
  url "https://github.com/Peltoche/lsd/archive/0.17.0.tar.gz"
  sha256 "65b03ae322c4d3ed47f502866b4da2b2c7029b6cb5dc989e98664d564a57de1d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c86fb71671114e8159c705a616a219461eb4c13e78aced6a90237b511191e145" => :catalina
    sha256 "409b2f2d69907b358d8b7ba32061f7f2cf44907a28699d5b3eb5fc16c5c2c810" => :mojave
    sha256 "3f5af56bcd518bdf9d3aabf02bef3972ff8101e1a81b9f0e788b8d27a163c372" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    output = shell_output("#{bin}/lsd -l #{prefix}")
    assert_match "README.md", output
  end
end
