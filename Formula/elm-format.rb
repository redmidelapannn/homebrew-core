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
    sha256 "507274c4b82f7418d42416d4f873b0f7b7d315d61defb1d587dc87998890bff0" => :high_sierra
    sha256 "39921e571409186ca26c90b97996f145ee7db30d0bf201865f5a24fc5a373940" => :sierra
    sha256 "4b73e75ae35876655c60da1851f048f0e7ab44d415f34e4987fa954336641d08" => :el_capitan
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
