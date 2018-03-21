require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag => "0.6.1-alpha",
      :revision => "24cbc66245289dd3ca5c08a14e86358dc039fcf3"
  version "0.6.1-alpha"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e386920a6d6520e79f4fecd94a11e907c0873219bbe9b89330d6333ede92bb9e" => :high_sierra
    sha256 "088469773fcd630e31fd196b21d45183cfe11dada5adaec1765b3005d1f99d6f" => :sierra
    sha256 "1576e23a7fb68afccca88672b19c97a3a96a6e7c84baa842ec90c8378a05e6ef" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    (buildpath/"elm-format").install Dir["*"]

    # GHC 8.4.1 compat
    # Reported upstream 21 Mar 2018 https://github.com/avh4/elm-format/issues/464
    (buildpath/"cabal.config").write <<~EOS
      allow-newer: elm-format:free, elm-format:optparse-applicative
      constraints: free < 6, optparse-applicative < 0.15
    EOS

    cabal_sandbox do
      cabal_sandbox_add_source "elm-format"
      cabal_install "--only-dependencies", "elm-format"
      cabal_install "--prefix=#{prefix}", "elm-format"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format-0.17", testpath/"Hello.elm", "--yes"
  end
end
