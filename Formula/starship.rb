class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.37.1.tar.gz"
  sha256 "feae2b69a41bd5abfc69b607860e6734bc25678e603a5c74397e4ef85eb1f874"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1dd3f46ce1a9d55f51b7f2ddbee9d338c77d695f3468250e30908689710d8ccc" => :catalina
    sha256 "a4fb4b6778d97f61ba8e33935937e9204fb932349de49e66f0fbf12b3b4e5726" => :mojave
    sha256 "1b3fc687c0b9f9ae8bdf270bd6b4bf94039780c398138aca0855dbfe1a5a174f" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
