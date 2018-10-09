class Procmail < Formula
  desc "Autonomous mail processor"
  homepage "https://web.archive.org/web/20151013184044/procmail.org/"
  # Note the use of the patched version from Apple
  url "https://opensource.apple.com/tarballs/procmail/procmail-14.tar.gz"
  sha256 "f3bd815d82bb70625f2ae135df65769c31dd94b320377f0067cd3c2eab968e81"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "c8f2a7330c1c9bd444f0a328ae752555248c996b7c47ecf7ddc3bfe7c844a2c4" => :mojave
    sha256 "60a451948ced32078b37a4b0ffc4a8eb0e7e524ccd81a5f572636e748aeebea4" => :high_sierra
    sha256 "d1b82d8dfa8b3bb7005f596472ae95ca524127fae18e39a51b196b293a5bebc1" => :sierra
  end

  def install
    system "make", "-C", "procmail", "BASENAME=#{prefix}", "MANDIR=#{man}",
           "LOCKINGTEST=1", "install"
  end

  test do
    path = testpath/"test.mail"
    path.write <<~EOS
      From alice@example.net Tue Sep 15 15:33:41 2015
      Date: Tue, 15 Sep 2015 15:33:41 +0200
      From: Alice <alice@example.net>
      To: Bob <bob@example.net>
      Subject: Test

      please ignore
    EOS
    assert_match /Subject: Test/, shell_output("#{bin}/formail -X 'Subject' < #{path}")
    assert_match /please ignore/, shell_output("#{bin}/formail -I '' < #{path}")
  end
end
