class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.4.tar.xz"
  sha256 "6043ec020d96358a4887a3ff09492c4f9f6b5bccc48dcdd8f28b15b1c6157a6f"
  revision 1

  bottle do
    cellar :any
    sha256 "50d5811a9f1e016c0b4af1ea3bfaf93455e19a76a903ebba956dbee17e70e1a8" => :high_sierra
    sha256 "766a9d138ed2acf5f4ab50c0159a840d5a55c68a9fcb9612153e8e5bbdaffb1a" => :sierra
    sha256 "8d145baba427d4e118df9856bb83504188f4a896a8b841a31ee03262a6ecab13" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "hidapi"
  depends_on "json-c"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <u2f-host.h>
      int main()
      {
        u2fh_devs *devs;
        u2fh_global_init (0);
        u2fh_devs_init (&devs);
        u2fh_devs_discover (devs, NULL);
        u2fh_devs_done (devs);
        u2fh_global_done ();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/u2f-host", "-L#{lib}", "-lu2f-host"
    system "./test"
  end
end
