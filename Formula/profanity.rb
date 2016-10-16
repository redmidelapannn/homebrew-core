class Profanity < Formula
  desc "Console based XMPP client"
  homepage "http://www.profanity.im/"
  url "http://www.profanity.im/profanity-0.5.0.tar.gz"
  sha256 "783be8aa6eab7192fc211f00adac136b21e580ea52d9c07128312a9609939668"

  bottle do
    rebuild 1
    sha256 "0e06bdde77ffb5dc2cfc01bf725f93fb3f1ae460269b8af2d7c84fba73df01bc" => :el_capitan
    sha256 "bfb4a55500143ed973df8da9e7b24148a912e7e2479be5558374b430c33d9957" => :yosemite
  end

  head do
    url "https://github.com/boothj5/profanity.git"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "ossp-uuid"
  depends_on "libstrophe"
  depends_on "readline"
  depends_on "glib"
  depends_on "openssl"
  depends_on "gnutls"
  depends_on "libotr" => :recommended
  depends_on "gpgme" => :recommended
  depends_on "terminal-notifier" => :optional

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-python-plugins",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "profanity", "-v"
  end
end
