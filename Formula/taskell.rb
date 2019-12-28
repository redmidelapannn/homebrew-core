require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.7.3.tar.gz"
  sha256 "b56a70e821024e7d2aa9a5bd8e0336bd41995f0c1c99359ed72293d881a744f5"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1418c91cbc930a099cef6a0741d6548f18a37ac148bfcea33102ba2e83490829" => :catalina
    sha256 "d5173e0505383cd4a7e6e682f5daf2586ae18751392b92ebeea331ecfb52c380" => :mojave
    sha256 "01b6cd526fdaa59b7a70880e395a3ef1d9caa82a10767c9bfb0e87326888ba9a" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "hpack" => :build

  def install
    system "hpack"
    install_cabal_package
  end

  test do
    (testpath/"test.md").write <<~EOS
      ## To Do

      - A thing
      - Another thing
    EOS

    expected = <<~EOS
      test.md
      Lists: 1
      Tasks: 2
    EOS

    assert_match expected, shell_output("#{bin}/taskell -i test.md")
  end
end
