class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.0.tar.gz"
  sha256 "afdc9d5e38bdd16f0b8b9d9d382b0faee0b1e0494446d686a08b256446f78b5d"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e52609c6c4e221f235073a402218d51c49328aef95ccb76d351c104e11b4a17f" => :high_sierra
    sha256 "4eb51e9adba6b548a5d2a2787339b9cb8c0308b857d5a48e3c0efc8b1a40ba98" => :sierra
    sha256 "7e9bfafe062ca15c5286ce9b66de9d58fd77ef64ee5f9f82145e98d47ccab74a" => :el_capitan
  end

  def install
    system "make"
    bin.install "bchunk"
    man1.install "bchunk.1"
  end

  test do
    (testpath/"foo.cue").write <<~EOS
      foo.bin BINARY
      TRACK 01 MODE1/2352
      INDEX 01 00:00:00
    EOS

    touch testpath/"foo.bin"

    system "#{bin}/bchunk", "foo.bin", "foo.cue", "foo"
    assert_predicate testpath/"foo01.iso", :exist?
  end
end
