class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180323.tar.gz"
  sha256 "4c498424cd6ded946c940f38df7cd01604a23059f258f05d979b2580eafc678b"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    rebuild 1
    sha256 "60374f7450f002f874c37efb84c03e5bed59b65803fb4349794275b02edbb59c" => :high_sierra
    sha256 "0eea2417ecfb4d5884928fd9d2c1ed3ee86be3a39810ac749f1daf3b547b59be" => :sierra
    sha256 "937e16dbafd0c0122ee42297c46fa93c06678f3689c4ecd50f55fb2ffa2945d2" => :el_capitan
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "notmuch"
  depends_on "openssl"
  depends_on "tokyo-cabinet"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-gpgme",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-ui=ncurses"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "debug_level=0", output.chomp
  end
end
