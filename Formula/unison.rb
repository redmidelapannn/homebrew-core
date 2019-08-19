class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.51.2.tar.gz"
  sha256 "a2efcbeab651be6df69cc9b253011a07955ecb91fb407a219719451197849d5e"
  head "https://github.com/bcpierce00/unison.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c8aea2c9fd4e8dbff3afda8eaaa7e2d8bdf3ca056c63055126b47640e899f3ae" => :mojave
    sha256 "78725002d3d49c8e565032dcbb7748aeff67c74b462690db55dee0ab7a271188" => :high_sierra
    sha256 "ef20db6215288c129a601b0e010edbbe4aec22bed74ee96f92c67e15c148b32e" => :sierra
  end

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
