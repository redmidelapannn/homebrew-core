class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/3.8.0.tar.gz"
  sha256 "daa183b9328704bbd00fc423144ce29652b1750e895dbf9c99b131d98b7f01ec"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "138f430c13a2ff0afa9e34130a63ae1b5eebc5c7ca6c314b5183622f6c26c077" => :catalina
    sha256 "30d5c04e36d9ac617aff7ccac289cada231a39ab81e808c3ca70ed9e44045830" => :mojave
    sha256 "a20320af9f08a3256c065987ec9f4f18a7752a8f1af7aa3ed5241caa8e245279" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "bash-snippets", :because => "Both install a `cheat` executable"

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
