class Httest < Formula
  desc "Provides a large variety of HTTP-related test functionality."
  homepage "https://htt.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/htt/htt2.4/httest-2.4.19/httest-2.4.19.tar.gz"
  sha256 "0cf2454de50995c14c460040cdf29863dd49082805e2bc61fb6938a7042b2dbd"

  bottle do
    cellar :any
    rebuild 1
    sha256 "9642ae1df1e8d907735897dbd37b8a1b74115830028b0cca939fe93972be20c0" => :sierra
    sha256 "ab6e95c23f749a9d0d5fe5491fe9890de7afc464dabcfaa185b9e6477f5e53b6" => :el_capitan
    sha256 "9d22810ec8d075de060f507f927d8ee51400485fc00cfa1ca6e95cf1614b6b51" => :yosemite
  end

  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl"
  depends_on "pcre"
  depends_on "lua"

  def install
    # Fix "fatal error: 'pcre/pcre.h' file not found"
    # Reported 9 Mar 2017 https://sourceforge.net/p/htt/tickets/4/
    (buildpath/"brew_include").install_symlink Formula["pcre"].opt_include => "pcre"
    ENV.prepend "CPPFLAGS", "-I#{buildpath}/brew_include"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-apr=#{Formula["apr"].opt_bin}",
                          "--enable-lua-module"
    system "make", "install"
  end

  test do
    (testpath/"test.htt").write <<-EOS.undent
      CLIENT 5
        _TIME time
      END
    EOS
    system bin/"httest", "--debug", testpath/"test.htt"
  end
end
