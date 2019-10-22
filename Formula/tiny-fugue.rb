class TinyFugue < Formula
  desc "Programmable MUD client"
  homepage "https://tinyfugue.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/tinyfugue/tinyfugue/5.0%20beta%208/tf-50b8.tar.gz"
  version "5.0b8"
  sha256 "3750a114cf947b1e3d71cecbe258cb830c39f3186c369e368d4662de9c50d989"
  revision 1

  bottle do
    rebuild 1
    sha256 "7a51e1401af0fc0e8d61f0648b991f51bd5589ff8e2f7421f3b5c9085f2e8118" => :catalina
    sha256 "962bd4e3d293078dc0930343b077a96ecc55d7cb1447301790e142dd8cbb949d" => :mojave
    sha256 "15b5de4edc4a70b5f4c112f380fd28741ceccafa9c25ba060522f452df8ebaa0" => :high_sierra
  end

  depends_on "libnet"
  depends_on "openssl@1.1"
  depends_on "pcre"

  conflicts_with "tee-clc", :because => "both install a `tf` binary"

  # pcre deprecated pcre_info. Switch to HB pcre-8.31 and pcre_fullinfo.
  # Not reported upstream; project is in stasis since 2007.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/tiny-fugue/5.0b8.patch"
    sha256 "22f660dc0c0d0691ccaaacadf2f3c47afefbdc95639e46c6b4b77a0545b6a17c"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-getaddrinfo",
                          "--enable-termcap=ncurses"
    system "make", "install"
  end
end
