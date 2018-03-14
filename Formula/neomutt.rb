class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://www.neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/neomutt-20180223.tar.gz"
  sha256 "10ba010017cf7db6bb5ac3e2116d6defad56d34be0dceea9d70a66d8510927bb"
  head "https://github.com/neomutt/neomutt.git"

  bottle do
    rebuild 1
    sha256 "8951d43016e0a41f16583559e21e4d0361dff10cee39ceda76ba9db7788a0b48" => :high_sierra
    sha256 "734e5f9c0022b42707c4037b08a451921c70ac91cfcf1771dadd3e13745d557c" => :sierra
    sha256 "94594e1071e9d083f743296583da9e77b2c118653aa7be538637892e6f13b34b" => :el_capitan
  end

  option "with-s-lang", "Build against slang instead of ncurses"

  depends_on "docbook-xsl" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn"
  depends_on "lmdb"
  depends_on "notmuch"
  depends_on "openssl"
  depends_on "tokyo-cabinet"
  depends_on "s-lang" => :optional

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --prefix=#{prefix}
      --enable-gpgme
      --gss
      --lmdb
      --notmuch
      --sasl
      --tokyocabinet
      --with-ssl=#{Formula["openssl"].opt_prefix}
    ]

    if build.with? "s-lang"
      args << "--with-ui=slang"
    else
      args << "--with-ui=ncurses"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "debug_level=0", output.chomp
  end
end
