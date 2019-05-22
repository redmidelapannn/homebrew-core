class Whois < Formula
  desc "Lookup tool for domain names and other internet resources"
  homepage "https://packages.debian.org/sid/whois"
  url "https://deb.debian.org/debian/pool/main/w/whois/whois_5.4.2.tar.xz"
  sha256 "eee33a3b3a56912fbf115a7dd24ed60314e2707a3ad6aa604ca2752c1ed01f57"
  head "https://github.com/rfc1036/whois.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "65b8b857db5ccada64d84c598eb92a0d3004807cf1204a19a3a2b71138788667" => :mojave
    sha256 "b7a946e9db5c3b3d2fd638de5ec3e83ad4233e8f1c67102b10c4dab435d0295a" => :high_sierra
    sha256 "7d276d09317d31675692f3329096de7c151094fe8c2afd8514474b1d2213d109" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libidn2"
  depends_on "openssl"

  stable do
      patch do
          url "https://gist.githubusercontent.com/mcandre/223d933dcc7dc9a36f1bb790d9e29823/raw/7afb16ad258f2d03ce249cf98efff4632acc9bed/Makefile.patch"
          sha256 "f60bd0d2ab0f795a8230d5967cc53325a461b7001664b43c236542d36eb92db9"
      end
  end

  def install
    ENV.append "LDFLAGS", "-L/usr/lib -liconv"

    system "make", "whois", "HAVE_ICONV=1"
    bin.install "whois"
    man1.install "whois.1"
    man5.install "whois.conf.5"

    system "make", "mkpasswd", "HAVE_ICONV=1"
    bin.install "mkpasswd"
    man1.install "mkpasswd.1"
  end

  def caveats; <<~EOS
    Debian whois has been installed as `whois` and may shadow the
    system binary of the same name.

    Debian mkpasswd has been installed as `mkpasswd` and may shadow the
    system binary of the same name.
  EOS
  end

  test do
    system "#{bin}/whois", "brew.sh"
    system "#{bin}/mkpasswd", "monkey"
  end
end
