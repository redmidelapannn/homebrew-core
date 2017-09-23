class WirouterKeyrec < Formula
  desc "Recover the default WPA passphrases from supported routers"
  homepage "http://www.salvatorefresta.net/tools/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/wirouterkeyrec/WiRouter_KeyRec_1.1.2.zip"
  mirror "https://distfiles.macports.org/wirouterkeyrec/WiRouter_KeyRec_1.1.2.zip"
  sha256 "3e59138f35502b32b47bd91fe18c0c232921c08d32525a2ae3c14daec09058d4"

  bottle do
    rebuild 1
    sha256 "348412216551c5ed18f5c8f36d6b9e6c311914bc9a771c349c7e415bfd007803" => :sierra
    sha256 "aee6467de4b71ecaaeb0d48ca26e361cd7e5be70e9997739ab06259177c735a5" => :el_capitan
  end

  def install
    inreplace "src/agpf.h", %r{/etc}, "#{prefix}/etc"
    inreplace "src/teletu.h", %r{/etc}, "#{prefix}/etc"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{prefix}",
                          "--exec-prefix=#{prefix}"
    system "make", "prefix=#{prefix}"
    system "make", "install", "DESTDIR=#{prefix}", "BIN_DIR=bin/"
  end

  test do
    system "#{bin}/wirouterkeyrec", "-s", "Alice-12345678"
  end
end
