class Nmh < Formula
  desc "The new version of the MH mail handler"
  homepage "https://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.7.tar.gz"
  sha256 "cd05c7ca2cae524ae99f6ba673463a5cdeff62df93e85913aa9277ae8304ce44"

  bottle do
    rebuild 1
    sha256 "a8e3643099ebf21285a9f7a6a76e85ab5ead98bb892ea72c9a79893531f46970" => :high_sierra
    sha256 "1f21e2e6537da10311b384286412191203cff0dd695a3b786af823139605ace3" => :sierra
    sha256 "dfa43d83702415ee518a7f746329ba9bc609a8168b4fc11a66bcbdb9df7745d4" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}", "--libdir=#{libexec}",
                          "--with-cyrus-sasl",
                          "--with-tls"
    system "make", "install"
  end

  test do
    (testpath/".mh_profile").write "Path: Mail"
    (testpath/"Mail/inbox/1").write <<~EOS
      From: Mister Test <test@example.com>
      To: Mister Nobody <nobody@example.com>
      Date: Tue, 5 May 2015 12:00:00 -0000
      Subject: Hello!

      How are you?
    EOS
    ENV["TZ"] = "GMT"
    output = shell_output("#{bin}/scan -width 80")
    assert_equal("   1  05/05 Mister Test        Hello!<<How are you? >>\n", output)
  end
end
