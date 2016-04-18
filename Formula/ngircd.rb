class Ngircd < Formula
  desc "Next generation IRC daemon"
  homepage "http://ngircd.barton.de/"
  url "http://ngircd.barton.de/pub/ngircd/ngircd-23.tar.gz"
  mirror "https://ngircd.mirror.3rz.org/pub/ngircd/ngircd-23.tar.gz"
  sha256 "99b8b67a975a9ae9b81c96bdee02133a10f515c718825d34cedcb64f1fc95e73"

  bottle do
    revision 1
    sha256 "62bb9f3f786a46a013e4f3edeaf16a06d6c5cd0b8b1393bcd78b62555e4bf69a" => :el_capitan
    sha256 "1851b6c9cb135a89e3ae00a478e08139d5d399306c9b018bd1fececf3a3977ab" => :yosemite
    sha256 "db69ef88c3a7084864349d9af432b64b92c8530998e92d70c545f758edcb29ac" => :mavericks
  end

  option "with-iconv", "Enable character conversion using libiconv."
  option "with-pam", "Enable user authentication using PAM."
  option "with-sniffer", "Enable IRC traffic sniffer (also enables additional debug output)."
  option "with-debug", "Enable additional debug output."

  # Older Formula used the next option by default, so keep it unless
  # deactivated by the user:
  option "without-ident", "Disable 'IDENT' ('AUTH') protocol support."

  depends_on "libident" if build.with? "ident"
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{HOMEBREW_PREFIX}/etc
      --enable-ipv6
      --with-openssl
    ]

    args << "--with-iconv" if build.with? "iconv"
    args << "--with-ident" if build.with? "ident"
    args << "--with-pam" if build.with? "pam"
    args << "--enable-debug" if build.with? "debug"
    args << "--enable-sniffer" if build.with? "sniffer"

    system "./configure", *args
    system "make", "install"

    prefix.install "contrib/MacOSX/de.barton.ngircd.plist.tmpl" => "de.barton.ngircd.plist"
    (prefix+"de.barton.ngircd.plist").chmod 0644

    inreplace prefix+"de.barton.ngircd.plist" do |s|
      s.gsub! ":SBINDIR:", sbin
      s.gsub! "/Library/Logs/ngIRCd.log", var/"Logs/ngIRCd.log"
    end
  end

  test do
    # Exits non-zero, so test version and match Author's name supplied.
    assert_match /Alexander/, pipe_output("#{sbin}/ngircd -V 2>&1")
  end
end
