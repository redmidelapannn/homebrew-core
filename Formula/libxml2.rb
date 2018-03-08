class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org/"
  url "http://xmlsoft.org/sources/libxml2-2.9.7.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libxml2/libxml2-2.9.7.tar.gz"
  sha256 "f63c5e7d30362ed28b38bfa1ac6313f9a80230720b7fb6c80575eeab3ff5900c"

  bottle do
    cellar :any
    rebuild 1
    sha256 "c9150ccb7a6220c1b21c8b1f2a51d8d3300f6af21e27f3bbbe959981c5a3cdbb" => :high_sierra
    sha256 "08b76a40d99320821227c7e83719e157aac4b67686a2f47c021f84f7cdd2e38d" => :sierra
    sha256 "859182deb6a2bd968e5461338d830f31c231ef2f59610f7f97d52f7aa2960263" => :el_capitan
  end

  head do
    url "https://git.gnome.org/browse/libxml2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "pkg-config" => :build
  end

  keg_only :provided_by_macos

  depends_on "python@2" if MacOS.version <= :snow_leopard

  def install
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-python",
                          "--without-lzma"
    system "make", "install"

    cd "python" do
      # We need to insert our include dir first
      inreplace "setup.py", "includes_dir = [", "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
      system "python", "setup.py", "install", "--prefix=#{prefix}"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxml/tree.h>

      int main()
      {
        xmlDocPtr doc = xmlNewDoc(BAD_CAST "1.0");
        xmlNodePtr root_node = xmlNewNode(NULL, BAD_CAST "root");
        xmlDocSetRootElement(doc, root_node);
        xmlFreeDoc(doc);
        return 0;
      }
    EOS
    args = shell_output("#{bin}/xml2-config --cflags --libs").split
    args += %w[test.c -o test]
    system ENV.cc, *args
    system "./test"

    ENV.prepend_path "PYTHONPATH", lib/"python2.7/site-packages"
    system "python2.7", "-c", "import libxml2"
  end
end
