class ElmFormat < Formula
  desc "Elm source code formatter, inspired by gofmt"
  homepage "https://github.com/avh4/elm-format"
  url "https://github.com/avh4/elm-format.git",
      :tag      => "0.8.3",
      :revision => "b97e3593d564a1e069c0a022da8cbd98ca2c5a4b"
  head "https://github.com/avh4/elm-format.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ea08bc7a48d890808ff6a4a4bd9e01bdae97cfe9f5f851058b67c7b2446f7670" => :catalina
    sha256 "3662cd93e8e6ba8d4d28c860e86486e6778de2c2b0b71ae27b02d3fc8f18e924" => :mojave
    sha256 "4478cc2bf684cad027b7f51ef05bc9531e3dcebaab762a1b1b4395049f5c0a53" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def build_elm_format_conf
    <<~EOS
      module Build_elm_format where

      gitDescribe :: String
      gitDescribe = "#{version}"
    EOS
  end

  def install
    defaults = buildpath/"generated/Build_elm_format.hs"
    defaults.write(build_elm_format_conf)

    (buildpath/"elm-format").install Dir["*"]

    cd "elm-format" do
      system "cabal", "v2-update"
      system "cabal", "v2-install", *std_cabal_v2_args
    end
  end

  test do
    src_path = testpath/"Hello.elm"
    src_path.write <<~EOS
      import Html exposing (text)
      main = text "Hello, world!"
    EOS

    system bin/"elm-format", "--elm-version=0.18", testpath/"Hello.elm", "--yes"
    system bin/"elm-format", "--elm-version=0.19", testpath/"Hello.elm", "--yes"
  end
end
