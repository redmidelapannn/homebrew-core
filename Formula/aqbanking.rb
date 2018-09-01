class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/aqbanking/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=03&release=217&file=02&dummy=aqbanking-5.7.8.tar.gz"
  sha256 "16f86e4cc49a9eaaa8dfe3206607e627873208bce45a70030c3caea9b5afc768"
  revision 1

  bottle do
    rebuild 1
    sha256 "fde4ceb36ab85ec78176b334a593f01746e39c1fd472b179e72373aa749adebf" => :mojave
    sha256 "45430c4c9ef8a21e07cd4bcf4bba571fb57946ec91f626a6e7733d3d957e4644" => :high_sierra
    sha256 "e6b0602dfd1225e8e2d4bcfc1334e3461c802ee0af30de1af1dafdd7db4f19fd" => :sierra
    sha256 "fb7a720a4107f9e10849b6cfa904dce1947ee549fde600394b8f7278c1903822" => :el_capitan
  end

  head do
    url "https://git.aquamaniac.de/git/aqbanking.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gwenhywfar"
  depends_on "libxmlsec1"
  depends_on "libxslt"
  depends_on "libxml2"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "ktoblzcheck" => :recommended

  def install
    ENV.deparallelize
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cli",
                          "--with-gwen-dir=#{HOMEBREW_PREFIX}"
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
