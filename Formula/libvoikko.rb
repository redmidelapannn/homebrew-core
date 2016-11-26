class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "http://voikko.puimula.org/"
  url "http://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.0.2.tar.gz"
  sha256 "0bfaaabd039024920713020671daff828434fcf4c89bce4601b94a377567f2a3"

  # Standard compatibility fixes for Clang, upstream pull request at
  # https://github.com/voikko/corevoikko/pull/22
  patch :p2 do
    url "https://github.com/voikko/corevoikko/commit/f69bab4.diff"
    sha256 "415fc284feccb3b55972177d73d32a445a4c9b790071637d8d64da9c86ab2928"
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "873fa919765eaea8b912e78e8bedbfb4db678da40c5ad2551e01732b63603f52" => :sierra
    sha256 "efff46077295ae45f7ec2bc7300be07d45eb2406356f7e51ac871754f7b0e399" => :el_capitan
    sha256 "f1d0d9fae6f9915a1da22c64df17ca930c51f0c02549ed7e1eeeaf9db4148fa9" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python3 => :build
  depends_on "foma" => :build
  depends_on "hfstospell"

  needs :cxx11

  resource "voikko-fi" do
    url "http://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.0.tar.gz"
    sha256 "02f7595dd7e3cee188184417d6a7365f9dc653b020913f5ad75d1f14b548fafd"
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
