class Rsync < Formula
  desc "Fast incremental file transfer"
  homepage "https://rsync.samba.org/"
  url "https://download.samba.org/pub/rsync/src/rsync-3.1.2.tar.gz"
  sha256 "ecfa62a7fa3c4c18b9eccd8c16eaddee4bd308a76ea50b5c02a5840f09c0a1c2"

  bottle do
    cellar :any_skip_relocation
    sha256 "8886746445972e8a14c20277e96de33c086c165a0acc42d400a52b7e0734020c" => :sierra
    sha256 "a00ae99907ee737aa7b06618e3f70ff2f68278e520aa48f303764159b617aa9e" => :el_capitan
    sha256 "09a1e92afe8b95ecffc778891fad51d87fbd40551a8d9118892fec825a3d8f63" => :yosemite
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    rsync --version
  end
end
