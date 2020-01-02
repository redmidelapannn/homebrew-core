require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.8.2.tar.gz"
  sha256 "6fc3c4922bfd960c9ea9c5f229619f1aedf7c227ae16e5cb1990f92e8f0abdf9"

  bottle do
    cellar :any_skip_relocation
    sha256 "1cb2e64a8558ae430f9c86f7f6d984edd3e8c4f25de4aa34f68cd588220823e1" => :catalina
    sha256 "810387856474b9e3e288dc233568c68aea21375045dc9f8d67f6a1356ec834b2" => :mojave
    sha256 "893e34ba0c3b18b51c01327ae2200a109487a5ea72206e1c85145a7a018d746a" => :high_sierra
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
