class Yaz < Formula
  desc "Toolkit for Z39.50/SRW/SRU clients/servers"
  homepage "https://www.indexdata.com/yaz"
  url "http://ftp.indexdata.dk/pub/yaz/yaz-5.16.0.tar.gz"
  sha256 "46708320152c1475f6a5ee6f29903caa76121c2440123051546c1b3403c78686"

  bottle do
    cellar :any
    revision 1
    sha256 "7b54395d9d3d4015f72060e52c13f273ff27e74468cbb23b6e5c3d45129ca302" => :el_capitan
    sha256 "b4f23e48c41ca0205482d5fd897d911bf14f05a02e54bbd94bba00082fb9aca1" => :yosemite
    sha256 "da053104b576d22891c20848f39eefc3a4254395522e940e7d1406b21c511d00" => :mavericks
  end

  head do
    url "https://github.com/indexdata/yaz.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended

  def install
    ENV.universal_binary if build.universal?

    system "./buildconf.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-xml2"
    system "make", "install"
  end

  test do
    # This test converts between MARC8, an obscure mostly-obsolete library
    # text encoding supported by yaz-iconv, and UTF8.
    marc8file = testpath/"marc8.txt"
    marc8file.write "$1!0-!L,i$3i$si$Ki$Ai$O!+=(B"
    result = shell_output("#{bin}/yaz-iconv -f marc8 -t utf8 #{marc8file}")
    result.force_encoding(Encoding::UTF_8) if result.respond_to?(:force_encoding)
    assert_equal "世界こんにちは！", result

    # Test ICU support if building with ICU by running yaz-icu
    # with the example icu_chain from its man page.
    if build.with? "icu4c"
      # The input string should be transformed to be:
      # * without control characters (tab)
      # * split into tokens at word boundaries (including -)
      # * without whitespace and Punctuation
      # * xy transformed to z
      # * lowercase
      configurationfile = testpath/"icu-chain.xml"
      configurationfile.write <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <icu_chain locale="en">
          <transform rule="[:Control:] Any-Remove"/>
          <tokenize rule="w"/>
          <transform rule="[[:WhiteSpace:][:Punctuation:]] Remove"/>
          <transliterate rule="xy > z;"/>
          <display/>
          <casemap rule="l"/>
        </icu_chain>
      EOS

      inputfile = testpath/"icu-test.txt"
      inputfile.write "yaz-ICU	xy!"

      expectedresult = <<-EOS.undent
        1 1 'yaz' 'yaz'
        2 1 '' ''
        3 1 'icuz' 'ICUz'
        4 1 '' ''
      EOS

      result = shell_output("#{bin}/yaz-icu -c #{configurationfile} #{inputfile}")
      assert_equal expectedresult, result
    end
  end
end
