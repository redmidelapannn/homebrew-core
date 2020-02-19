class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.29.2.tar.gz"
  sha256 "bc2f36b5d4fc9890c69f607d54da873032628462e88c545dd633d2c787a544a5"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4fcdb2e423fa761e343f1c1895681e35938a4b4a16734519621688d100322199" => :catalina
    sha256 "b1c3c7a73fdf2673811face2ba9e957e5972e22884a52df09bd20d8623389c9d" => :mojave
    sha256 "ab5fa31b4564db4a27e823f51f4c703ecdbc44a615262e5d12faa4a55dc72d90" => :high_sierra
  end

  depends_on "python@3.8" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile", "python", "python3"

    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
