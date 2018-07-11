class Unison < Formula
  desc "File synchronization tool for OSX"
  homepage "https://www.cis.upenn.edu/~bcpierce/unison/"
  url "https://github.com/bcpierce00/unison/archive/v2.51.2.tar.gz"
  sha256 "a2efcbeab651be6df69cc9b253011a07955ecb91fb407a219719451197849d5e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1c8c97f540804d67546c2c91aa0b96739f9cdf93168921d2677aa0660abc3bd7" => :high_sierra
    sha256 "09f2bc87b8a3aee04b29d550a701d9d6154b790b788bb368fc83c18546ed0087" => :sierra
    sha256 "bf659ad7ec059de8c08e4d49316d48ed0bf1bb1bab09111b9bc978bee928aa30" => :el_capitan
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
