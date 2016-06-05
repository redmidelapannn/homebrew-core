class Aescrypt < Formula
  desc "Program for encryption/decryption"
  homepage "http://aescrypt.sourceforge.net/"
  url "http://aescrypt.sourceforge.net/aescrypt-0.7.tar.gz"
  sha256 "7b17656cbbd76700d313a1c36824a197dfb776cadcbf3a748da5ee3d0791b92d"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "6a2efa6c97c73a740f0f84bbedb6a291803adc86813929a42f814b1b84f1dc4f" => :el_capitan
    sha256 "df8437d7348df3f8e32f031cd84eafcc8246016d1b9ac857390b152cd54fb787" => :yosemite
    sha256 "70a0210824c6625a748aea13fe942da4785417e63724aa14bb2e532000357e10" => :mavericks
  end

  def install
    system "./configure"
    system "make"
    bin.install "aescrypt", "aesget"
  end

  test do
    (testpath/"key").write "kk=12345678901234567890123456789abc0"
    original_text = "hello"
    cipher_text = pipe_output("#{bin}/aescrypt -k #{testpath}/key -s 128", original_text)
    deciphered_text = pipe_output("#{bin}/aesget -k #{testpath}/key -s 128", cipher_text)
    assert_not_equal original_text, cipher_text
    assert_equal original_text, deciphered_text
  end
end
