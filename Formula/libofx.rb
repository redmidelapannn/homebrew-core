class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.9.13.tar.gz"
  sha256 "57eaf97cddbaf82c24f26b8f5cf8b2fbfd4969c74500a2c9acc9082b83bcc0e4"

  bottle do
    rebuild 1
    sha256 "afd55589d1acf2b93fa139c7035122b7934ca3c312c13c79640240b08ae04d5d" => :mojave
    sha256 "aa6e514c67895c53e01da6660c9b7a6976502cced51bae161f0d9d6f9d7a9a6b" => :high_sierra
    sha256 "1fdf11e014eb69bb0b2be2dbb8f6f93ac57f9bdb640da5f186d98015ab2b85f5" => :sierra
    sha256 "ac483a60c6b80762107876a5039a9d0e693092d738a3c8e1489702fcdd815798" => :el_capitan
  end

  depends_on "open-sp"

  def install
    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
