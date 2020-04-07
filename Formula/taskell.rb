require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.9.3.tar.gz"
  sha256 "bbe81d4a8f04ca6bde0ef6c18b5cc29730e876ea40b0c21a8dfe9c538aa39235"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a5a16394bb14bac253f1c49fc5b2407013d8b53d6cd8bb4d2247df1925295e98" => :catalina
    sha256 "127863754b2247850b6569698c12667d1c137af38f8828dcffdca670550b58ef" => :mojave
    sha256 "b1f8c3a69a80d7e7f8b448efcc647e0dacf1a9498a7f48389d45d57b0d0d961a" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.8" => :build
  depends_on "hpack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
