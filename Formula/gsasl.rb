class Gsasl < Formula
  desc "SASL library command-line interface"
  homepage "https://www.gnu.org/software/gsasl/"
  url "https://ftpmirror.gnu.org/gsasl/gsasl-1.8.0.tar.gz"
  mirror "https://ftp.gnu.org/gsasl/gsasl-1.8.0.tar.gz"
  sha256 "310262d1ded082d1ceefc52d6dad265c1decae8d84e12b5947d9b1dd193191e5"

  bottle do
    cellar :any
    rebuild 3
    sha256 "dc7c98a6d4f6b8fe1ded3e47aecd4df8e9dae25474af2117896a2fd1ff7d52e3" => :sierra
    sha256 "65888138a763b3c941cc0336a0561c7ba0962b8d8e27dd843da078cc86078453" => :el_capitan
    sha256 "36052c523024a48a3da99c979437523dcdec95dfc176a0e5dbf7eac2d23abdbc" => :yosemite
  end

  depends_on "libntlm" => :optional

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--with-gssapi-impl=mit",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gsasl")
  end
end
