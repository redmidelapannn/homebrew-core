require "language/node"

class Unravel < Formula
  desc "Command-line client for Clojure REPLs"
  homepage "https://github.com/pesterhazy/unravel"
  url "https://github.com/pesterhazy/unravel/archive/0.2.2.tar.gz"
  sha256 "144b2a96dc5900dada9e668f765ac63d55b97770525f1c994b8b41084048a9cc"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c07ab4c5db0f18ceed763436966178c5ccc850dd3476f98184a7452b2d4ae008" => :mojave
    sha256 "f2f2eae7237669de24b7ce414f5cca1f6e26aa099cdb6b1d7db9fbe35a1e368b" => :high_sierra
    sha256 "4047edfdc47056273e1adbce27883822d55cd209b4167ba412c18eb5f84df01e" => :sierra
  end

  depends_on "lumo"
  depends_on "node"

  def install
    # This is installed by Homebrew
    inreplace "package.json", /"lumo-cljs": ".+?",/, ""
    inreplace "bin/unravel",
      '"${UNRAVEL_HOME}/node_modules/lumo-cljs/bin/lumo"', "lumo"

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    (bin/"unravel").write_env_script libexec/"bin/unravel",
      :UNRAVEL_HOME => libexec/"lib/node_modules/unravel-repl"
  end

  test do
    # We'd need a REPL to connect to in order to have a proper test
    assert_match "Socket error", shell_output("#{bin}/unravel localhost 1", 1)
  end
end
