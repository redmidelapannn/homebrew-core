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
    sha256 "b62b91ebb9294a7e85dc9a6171480bd6aa0f294d07845258f7fd64ef164cbed2" => :high_sierra
    sha256 "9880dc19791ccfc8e9bd25cd7ca3de0e9d7f3ff7e29e4b7b3ef66bf45f88501b" => :sierra
    sha256 "0e703ed177582c0dded9ec68875c26c783df8372d9de0169b2aa324523cdae39" => :el_capitan
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
