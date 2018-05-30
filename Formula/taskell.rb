require "language/haskell"

class Taskell < Formula
  include Language::Haskell::Cabal

  desc "Command-line Kanban board/task manager with support for Trello"
  homepage "https://taskell.app"
  url "https://github.com/smallhadroncollider/taskell/archive/1.2.6.tar.gz"
  sha256 "ffd2028ff18b08dba2a890b3e7d76d20a1f78698416d5061274ad062140a5731"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "031af1ae342dd62b8d7a9243d921e7c977a35daeceb63a2cddddc0be5e0ca8d2" => :high_sierra
    sha256 "ade0a2bc70ade07110394c7c948c791c735274132b74f589d2bacbc151127213" => :sierra
    sha256 "f3c43b6d352b6c0e5205ec591bf7db93321816216471774e0752bba1e3c413a0" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    cabal_sandbox do
      cabal_install "hpack"
      system "./.cabal-sandbox/bin/hpack"
      install_cabal_package
    end
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
