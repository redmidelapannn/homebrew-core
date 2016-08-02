class Libxml2 < Formula
  desc "GNOME XML library"
  homepage "http://xmlsoft.org"
  url "http://xmlsoft.org/sources/libxml2-2.9.4.tar.gz"
  mirror "ftp://xmlsoft.org/libxml2/libxml2-2.9.4.tar.gz"
  sha256 "ffb911191e509b966deb55de705387f14156e1a56b21824357cdf0053233633c"

  bottle do
    cellar :any
    revision 1
    sha256 "bc86ca41c5689f5bb822c57e952c4910708d6ad5b96d0e6d08192d6cf8f8db0f" => :el_capitan
    sha256 "acaf30dda07a2f8260c1253b0ea8c9f8ed3d3b7c2e89c5d335a91b2652be61ae" => :yosemite
    sha256 "26fc2d34e6f42f9c05f3ff454ff754129933c726932060c671efd247848a7395" => :mavericks
  end

  head do
    url "https://git.gnome.org/browse/libxml2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_by_osx

  option :universal

  depends_on :python => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def install
    ENV.universal_binary if build.universal?
    if build.head?
      inreplace "autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          ((build.with? "python") ? "--with-python" : "--without-python"),
                          "--without-lzma"
    system "make"
    ENV.deparallelize
    system "make", "install"

    if build.with? "python"
      cd "python" do
        # We need to insert our include dir first
        inreplace "setup.py", "includes_dir = [", "includes_dir = ['#{include}', '#{MacOS.sdk_path}/usr/include',"
        system "python", "setup.py", "install", "--prefix=#{prefix}"
      end
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
  end
end
