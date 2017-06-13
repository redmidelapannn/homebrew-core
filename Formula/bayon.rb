class Bayon < Formula
  desc "Simple and fast hard-clustering tool"
  homepage "https://github.com/fujimizu/bayon"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/bayon/bayon-0.1.1.tar.gz"
  sha256 "1749f8d2202459e33dd739e62fd8c128facaf16a06cb3f38a9e4f10cce542e0c"

  bottle do
    cellar :any
    sha256 "c1e2883be3e409c82ef64c13cd99b233c4da680bc80946cfad9ac56ba4bb1275" => :sierra
    sha256 "ade9a0ab1ff8a37609615979a54b8316378fef24c952de1a89381b1f43b8b489" => :el_capitan
    sha256 "6f38bc11e10f0d4d77eb50f9b26114030c95783b4082d040d0d672fee81164c0" => :yosemite
  end

  depends_on "google-sparsehash" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bayon", "-v"
  end
end
