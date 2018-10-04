class UnisonAT248 < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.48.15v4.tar.gz"
  sha256 "f8c7e982634bbe1ed6510fe5b36b6c5c55c06caefddafdd9edc08812305fdeec"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0dcbc445e52c36e8855a246e1e02f3518e988ffb2477782f859734d23ebd2c3" => :mojave
    sha256 "21e115b208141a0cd00a93c8f9706c548392571cca291108fbf5a6f9ea90473e" => :high_sierra
    sha256 "8ad3323b5597820faebca4833255470ca73cb212d8747522d4a6826c1ebd9bfe" => :sierra
  end

  keg_only :versioned_formula

  depends_on "ocaml" => :build

  def install
    ENV.deparallelize
    ENV.delete "CFLAGS" # ocamlopt reads CFLAGS but doesn't understand common options
    ENV.delete "NAME" # https://github.com/Homebrew/homebrew/issues/28642
    system "make", "UISTYLE=text"
    bin.install "src/unison"
    prefix.install_metafiles "src"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/unison -version")
  end
end
