class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20200320.tar.gz"
  sha256 "69daf2e0633dee7e8bdba74ab714adfa70e8f078028b56d612228c2aa836aafa"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    rebuild 1
    sha256 "e8e4b6c6e8d7daebed1bbfaf849b38d0e09224266dde2122f9cb467262ca2d56" => :catalina
    sha256 "2a1ea654b5139f2951c207e6b6f2d37c71cf0ea33b93e635e69980c71aac5531" => :mojave
    sha256 "16cd4e655bf901f83cfdf5c91119ffdabaac87e105c41412141b55c56b943dab" => :high_sierra
  end

  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "tokyo-cabinet"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-doc",
                          "--enable-gpgme",
                          "--with-gpgme=#{Formula["gpgme"].opt_prefix}",
                          "--gss",
                          "--lmdb",
                          "--notmuch",
                          "--sasl",
                          "--tokyocabinet",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--with-ui=ncurses",
                          "--lua",
                          "--with-lua=#{Formula["lua"].prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
