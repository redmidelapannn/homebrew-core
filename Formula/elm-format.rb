require "language/haskell"

class ElmFormat < Formula
  include Language::Haskell::Cabal
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag => "0.6.1-alpha",
      :revision => "24cbc66245289dd3ca5c08a14e86358dc039fcf3"
  version "0.6.1-alpha"
  revision 1
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "61563691d11419d4cb1cd849694fa36b72c00939a4be294c53fb505fdcee1598" => :sierra
    sha256 "38d1b023cbdb0843d13b173e89ca29406807ef6568af5d19041ea226613e9a84" => :el_capitan
    sha256 "d7c35dbdebd5b8d9b18347fbf0ec502777832e392df9df22328e73b1c3f1b882" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    (buildpath/"elm-format").install Dir["*"]

    cabal_sandbox do
      cabal_sandbox_add_source "elm-format"
      cabal_install "--only-dependencies", "elm-format"
      cabal_install "--prefix=#{prefix}", "elm-format"
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<-EOS.undent
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format-0.17", testpath/"Hello.elm", "--yes"
  end
end
