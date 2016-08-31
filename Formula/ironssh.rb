class Ironssh < Formula
  desc "Fork of OpenSSH adding transparent E2E encryption to file transfers"
  homepage "https://github.com/ironcorelabs/ironssh"
  url "https://github.com/IronCoreLabs/ironssh/archive/0.9.1.tar.gz"
  sha256 "6b2f78244dd836afdf6da561fda73d16fe42477b7f4034b1aeb09d75f23aff47"

  bottle do
    sha256 "6533d3dc31d956b06faaa8b146c319bf4d53fdb3c1ed928025812bb99ea459e7" => :el_capitan
    sha256 "56d3a8308eb5f899788b4878f9c564576f70dee5404e2b99387d1382e17cb7e7" => :yosemite
    sha256 "d0ee7546a5e0bb2a73c914fec617d18e15068fee517699a6c1a737d43c81e222" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "openssl"
  depends_on "libsodium"

  def install
    system "autoreconf"

    system "./configure",
                          "--with-ssl-dir=#{Formula["openssl"].opt_prefix}",
                          "--with-libedit=/usr",
                          "--prefix=#{prefix}"

    system "make", "SSH_PROGRAM=/usr/bin/ssh", "ironsftp"
    system "make", "install"
  end

  test do
    system "make", "iron-tests"
  end
end
