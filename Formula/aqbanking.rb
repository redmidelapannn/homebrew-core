class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/home/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=03&release=208&file=01&dummy=aqbanking-5.6.12.tar.gz"
  sha256 "0652706a487d594640a7d544271976261165bf269d90dc70447b38b363e54b22"
  head "https://git.aqbanking.de/git/aqbanking", :using => :git

  bottle do
    rebuild 1
    sha256 "b733c9edf1f604a2d9dbe42dceb9a75bc9168a0451af53f9d4d574e9607a594b" => :sierra
    sha256 "f0417d71ff41efc34723156fc077533166e22a0578af8b79757259e188135cd6" => :el_capitan
    sha256 "be9da44f6b67327a561e5402ecfe2bf3dc9fafb507959a7bb489539b6d10c734" => :yosemite
  end

  depends_on "gwenhywfar"
  depends_on "libxmlsec1"
  depends_on "libxslt"
  depends_on "libxml2"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "pkg-config" => :build
  depends_on "ktoblzcheck" => :recommended

  def install
    ENV.deparallelize
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
    (testpath/context).write <<-EOS.undent
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
    assert_match /^Account\s+110000000\s+000123456789\s+STRIPE TEST BANK\s+03.01.2014\s+12:00\s+1324.36\s+USD\s+$/, shell_output("#{bin}/aqbanking-cli listbal -c #{context}")
  end
end
