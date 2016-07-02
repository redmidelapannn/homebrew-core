class Libnfs < Formula
  desc "C client library for NFS"
  homepage "https://github.com/sahlberg/libnfs"
  url "https://github.com/sahlberg/libnfs/archive/libnfs-1.10.0.tar.gz"
  sha256 "7f6c62a05c7e0f0749f2b13f178a4ed7aaf17bd09e65a10bb147bfe9807da272"

  bottle do
    cellar :any
    sha256 "fc7c09992eed1189ee5aadd9ea76e2805c7cba9ed910dd572526d80c1d108412" => :el_capitan
    sha256 "5e5b0bef16c703596a928b0ff474264745f2b33a86041af948a2736f41713a5e" => :yosemite
    sha256 "7e89a3a33331387578ae4ef53037960c689e19c2f4a788f7763841d3036e8e0d" => :mavericks
  end

  depends_on "libtool" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <nfsc/libnfs.h>

      int main(void)
      {
        int result = 1;
        struct nfs_context *nfs = NULL;
        nfs = nfs_init_context();

        if (nfs != NULL) {
            result = 0;
            nfs_destroy_context(nfs);
        }

        return result;
      }
    EOS
    system ENV.cc, "test.c", "-lnfs", "-o", "test"
    system "./test"
  end
end
