class Bedtools < Formula
  desc "Tools for genome arithmetic (set theory on the genome)"
  homepage "https://github.com/arq5x/bedtools2"
  url "https://github.com/arq5x/bedtools2/archive/v2.28.0.tar.gz"
  sha256 "0f3e5990b5713388531de699d43d195f1535a5772d832acfd47baa151a3a7e59"

  bottle do
    cellar :any_skip_relocation
    sha256 "d564e46ed6f3a6a559f829175d01780dd71162a9a83115c4e5022b7a095e0ae9" => :mojave
    sha256 "ca1a234e9bcdb62f4c71aad27a12c1b286c0a0dd9101b22c8a55492c35b50a68" => :high_sierra
    sha256 "96e8d3f30f6b0f542b2fa17ce324d82c7c2ed1c8c579007fd7138dbbae63188e" => :sierra
    sha256 "56d2a63e1193f1326505c9a1829b7a4c6257261734a775fce0829cd7accb84f3" => :el_capitan
  end

  depends_on "xz"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
    prefix.install "RELEASE_HISTORY"
  end

  test do
    (testpath/"t.bed").write "c\t1\t5\nc\t4\t9"
    assert_equal "c\t1\t9", shell_output("#{bin}/bedtools merge -i t.bed").chomp
  end
end
