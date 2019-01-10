class Sipsak < Formula
  desc "SIP Swiss army knife"
  homepage "https://github.com/nils-ohlmeier/sipsak/"
  url "https://downloads.sourceforge.net/project/sipsak.berlios/sipsak-0.9.6-1.tar.gz"
  version "0.9.6"
  sha256 "5064c56d482a080b6a4aea71821b78c21b59d44f6d1aa14c27429441917911a9"

  bottle do
    cellar :any
    rebuild 1
    sha256 "ec09fbad8db21be911af14c791ce615ab9c1c09c54291ff9d06e68d6c36c80f1" => :mojave
    sha256 "1dddab1931a734faba13716ee041b990e9dddad987a22601dbd14fc63a3ccc94" => :high_sierra
    sha256 "b130367046fa44a12b34924f67ad95d69584ec4a1e29259e56e7b1105100960c" => :sierra
  end

  depends_on "openssl"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipsak", "-V"
  end
end
