class Hpack < Formula
  desc "Modern format for Haskell packages"
  homepage "https://github.com/sol/hpack"
  url "https://github.com/sol/hpack/archive/0.33.0.tar.gz"
  sha256 "954b02fd01ee3e1bc5fddff7ec625839ee4b64bef51efa02306fbcf33008081e"
  head "https://github.com/sol/hpack.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "f31bcb662aad36c0a27731f0cb48573da995442adfd6cb69cd893cc80bdb01b2" => :catalina
    sha256 "979b88fe4435042e49d89f7a26506e705f081edf16bb7d56ffdaeaa71291c79b" => :mojave
    sha256 "783f34828fb5398ee1d4883dab6552aabedcb6229826cfdf72c9592c74e79b41" => :high_sierra
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  # Testing hpack is complicated by the fact that it is not guaranteed
  # to produce the exact same output for every version.  Hopefully
  # keeping this test maintained will not require too much churn, but
  # be aware that failures here can probably be fixed by tweaking the
  # expected output a bit.
  test do
    (testpath/"package.yaml").write <<~EOS
      name: homebrew
      dependencies: base
      library:
        exposed-modules: Homebrew
    EOS
    expected = <<~EOS
      name:           homebrew
      version:        0.0.0
      build-type:     Simple

      library
        exposed-modules:
            Homebrew
        other-modules:
            Paths_homebrew
        build-depends:
            base
        default-language: Haskell2010
    EOS

    system "#{bin}/hpack"

    # Skip the first lines because they contain the hpack version number.
    assert_equal expected, (testpath/"homebrew.cabal").read.lines[8..-1].join
  end
end
