class Starship < Formula
  desc "The cross-shell prompt for astronauts"
  homepage "https://starship.rs"
  url "https://github.com/starship/starship/archive/v0.39.0.tar.gz"
  sha256 "8ebeaf2f238d0513f97eeeecc1214b4f22b3431f2fc4ed0d9afd3868b4dd3c17"
  head "https://github.com/starship/starship.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8306db11565e0f37816ae89e3e15e1aa96e58a6cf97df03fbf5cc9bfc9f849f1" => :catalina
    sha256 "807f14a3c3fb9e15b59d8898214912ed4d8c6b6e3fd22fe7b920cf188802bc82" => :mojave
    sha256 "9b9e408d1807f729b4502603cff72df262c446043d159fdcbc834828934cb34a" => :high_sierra
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
