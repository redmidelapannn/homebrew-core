require "language/haskell"

class Elm < Formula
  include Language::Haskell::Cabal

  desc "Functional programming language for building browser-based GUIs"
  homepage "https://elm-lang.org"
  url "https://github.com/elm/compiler/archive/0.19.0.tar.gz"
  sha256 "494df33724224307d6e2b4d0b342448cc927901483384ee4f8cfee2cb38e993c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "15a389c8750eee6a3146528121a3632c1355379fdf45cd7654dea4ac71639e97" => :mojave
    sha256 "ae4dfcabae279ebb53bb6a1328223ad8d0cca130f1b50dec8d0d396afbd65496" => :high_sierra
    sha256 "b42f9017771e0f072b43d213c16a41ff528b1b2f67c7f767b7abe5ef5c013e6a" => :sierra
    sha256 "ccfcd27a268f032477113cc61ad7df43d4c299c6deb5104c1b6be9615555e9fe" => :el_capitan
  end

  depends_on "ghc@8.2" => :build
  depends_on "cabal-install" => :build

  def install
    # elm-compiler needs to be staged in a subdirectory for the build process to succeed
    (buildpath/"elm-compiler").install Dir["*"]

    cabal_sandbox do
      cabal_sandbox_add_source "elm-compiler"
      cabal_install "--only-dependencies", "elm"
      cabal_install "--prefix=#{prefix}", "elm"
    end
  end

  test do
    # create elm.json
    elm_json_path = testpath/"elm.json"
    elm_json_path.write <<~EOS
      {
        "type": "application",
        "source-directories": [
                  "."
        ],
        "elm-version": "0.19.0",
        "dependencies": {
                "direct": {
                    "elm/browser": "1.0.0",
                    "elm/core": "1.0.0",
                    "elm/html": "1.0.0"
                },
                "indirect": {
                    "elm/json": "1.0.0",
                    "elm/time": "1.0.0",
                    "elm/url": "1.0.0",
                    "elm/virtual-dom": "1.0.0"
                }
        },
        "test-dependencies": {
          "direct": {},
            "indirect": {}
        }
      }
    EOS

    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    out_path = testpath/"index.html"
    system bin/"elm", "make", src_path, "--output=#{out_path}"
    assert_predicate out_path, :exist?
  end
end
