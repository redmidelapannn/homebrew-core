class Bchunk < Formula
  desc "Convert CD images from .bin/.cue to .iso/.cdr"
  homepage "http://he.fi/bchunk/"
  url "http://he.fi/bchunk/bchunk-1.2.0.tar.gz"
  sha256 "afdc9d5e38bdd16f0b8b9d9d382b0faee0b1e0494446d686a08b256446f78b5d"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "e29da4dbd99a3a7b582e994ec78cf0018eec1cd82c9ace86b3961c2d6aeb64f6" => :high_sierra
    sha256 "ba5ad8a82621672b6757969aba543e0cece6e62b5f96af4c95017eaf92f0cc5a" => :sierra
    sha256 "206bcc4d69cd733d66350c98a095bbb48c5806e88b1caa2ab7fa7b8588ab2530" => :el_capitan
  end

  # Last upstream release was in 2004, so probably safe to assume this isn't
  # going away any time soon.
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/b/bchunk/bchunk_1.2.0-12.1.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/b/bchunk/bchunk_1.2.0-12.1.debian.tar.xz"
    sha256 "8c7b530e37f0ebcce673c74962214da02aff7bb1ecc96a4dd359e6115f5c0f57"
    apply "patches/01-track-size.patch",
          "patches/CVE-2017-15953.patch",
          "patches/CVE-2017-15955.patch"
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
