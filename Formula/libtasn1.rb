class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.14.tar.gz"
  sha256 "9e604ba5c5c8ea403487695c2e407405820d98540d9de884d6e844f9a9c5ba08"

  bottle do
    cellar :any
    sha256 "7e3bd1058d6d29f0b7a377ebceb5ef9bfa895c37db321264f382c3faf076b2fe" => :mojave
    sha256 "ffa71f6eade986e9cdd08f649634c0bee9f0a23992b6d339bc1ff2a33749f539" => :high_sierra
    sha256 "a35fe8b2b11e7a000987c9540b0596c5fd50cdd88a34647122a29658b64830b1" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"pkix.asn").write <<~EOS
      PKIX1 { }
      DEFINITIONS IMPLICIT TAGS ::=
      BEGIN
      Dss-Sig-Value ::= SEQUENCE {
           r       INTEGER,
           s       INTEGER
      }
      END
    EOS
    (testpath/"assign.asn1").write <<~EOS
      dp PKIX1.Dss-Sig-Value
      r 42
      s 47
    EOS
    system "#{bin}/asn1Coding", "pkix.asn", "assign.asn1"
    assert_match /Decoding: SUCCESS/, shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
