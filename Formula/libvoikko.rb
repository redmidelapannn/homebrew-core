class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.1.1.tar.gz"
  sha256 "bb179360abdb92f9459f4d4090e56c9d9d8a3ebe9161a4c4bcd19971d59f9124"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "159ee3deb82c681bd4258bf4a539f560d6cf64eafea2a2cba8f861392608e36e" => :high_sierra
    sha256 "58fcbe8d8974a37b8270df986f67ed71925f939158228d17afe2ac0d60787a60" => :sierra
    sha256 "d95371ee2e53ebfa7dbb1e8b90afb1cf3121489c241f07eb08ebbe2a5b4f3409" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "python3" => :build
  depends_on "foma" => :build
  depends_on "hfstospell"

  needs :cxx11

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.1.tar.gz"
    sha256 "71a823120a35ade6f20eaa7d00db27ec7355aa46a45a5b1a4a1f687a42134496"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
