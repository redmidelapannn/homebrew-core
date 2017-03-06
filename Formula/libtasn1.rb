class Libtasn1 < Formula
  desc "ASN.1 structure parser library"
  homepage "https://www.gnu.org/software/libtasn1/"
  url "https://ftpmirror.gnu.org/libtasn1/libtasn1-4.10.tar.gz"
  mirror "https://ftp.gnu.org/gnu/libtasn1/libtasn1-4.10.tar.gz"
  sha256 "681a4d9a0d259f2125713f2e5766c5809f151b3a1392fd91390f780b4b8f5a02"

  bottle do
    cellar :any
    rebuild 1
    sha256 "3ea8a0c53333503a333dac6c1f8643a78ccb90d063c621f93729ca8a7176cc8a" => :sierra
    sha256 "8066c43cef5e856b1c357d11491267b793c0222d3d076bced43b24a65b5fb6fb" => :el_capitan
    sha256 "9560bb8c2c0937222af15646c1632013bd8459f8387851f6388f252a095cde46" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"pkix.asn").write <<-EOS.undent
      PKIX1 { }
      DEFINITIONS IMPLICIT TAGS ::=
      BEGIN
      Dss-Sig-Value ::= SEQUENCE {
           r       INTEGER,
           s       INTEGER
      }
      END
    EOS
    (testpath/"assign.asn1").write <<-EOS.undent
      dp PKIX1.Dss-Sig-Value
      r 42
      s 47
    EOS
    system "#{bin}/asn1Coding", "pkix.asn", "assign.asn1"
    assert_match /Decoding: SUCCESS/, shell_output("#{bin}/asn1Decoding pkix.asn assign.out PKIX1.Dss-Sig-Value 2>&1")
  end
end
