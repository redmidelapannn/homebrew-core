class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/aqbanking/"
  url "https://www.aquamaniac.de/rdm/attachments/download/269/aqbanking-6.1.2.tar.gz"
  sha256 "0b54c70a8ab1bd5537d8b26d05a9e44db0600b64d8cbb63c34018dee11f67190"

  bottle do
    sha256 "2d6b61bec317b9c8df61a26c5ef9f055fa974a583da84df299badb9b13f526ab" => :catalina
    sha256 "11c60072cd615aa3a72271b91ff6a1ed8a43b099605e74c9679aefa358b0e6fa" => :mojave
    sha256 "995c36a194200186f6320b9f3ab2741b9a2d5b38552a24b428e90c34ee40f39f" => :high_sierra
  end

  head do
    url "https://git.aquamaniac.de/git/aqbanking.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["gwenhywfar"].lib/"pkgconfig"
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libxmlsec1"].lib

    ENV.deparallelize

    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cli"
    system "make", "check"
    system "make", "install"
  end

  test do
    ENV["TZ"] = "UTC"
    context = "balance.ctx"
    (testpath/context).write <<~EOS
      accountInfoList {
        accountInfo {
          char bankCode="110000000"
          char bankName="STRIPE TEST BANK"
          char accountNumber="000123456789"
          char accountName="demand deposit"
          char iban="US44110000000000123456789"
          char bic="BYLADEM1001"
          char owner="JOHN DOE"
          char currency="USD"
          int  accountType="0"
          int  accountId="2"

          statusList {
            status {
              int  time="1388664000"

              notedBalance {
                value {
                  char value="123456%2F100"
                  char currency="USD"
                } #value

                int  time="1388664000"
              } #notedBalance
            } #status

            status {
              int  time="1388750400"

              notedBalance {
                value {
                  char value="132436%2F100"
                  char currency="USD"
                } #value

                int  time="1388750400"
              } #notedBalance
            } #status
          } #statusList

        } # accountInfo
      } # accountInfoList
    EOS

    match = "Account 110000000 000123456789 STRIPE TEST BANK 03.01.2014 12:00 1324.36 USD"
    out = shell_output("#{bin}/aqbanking-cli listbal -c #{context}")
    assert_match match, out.gsub(/\s+/, " ")
  end
end
