class Libmodplug < Formula
  desc "Library from the Modplug-XMMS project"
  homepage "http://modplug-xmms.sourceforge.net/"
  url "https://downloads.sourceforge.net/modplug-xmms/libmodplug/0.8.8.5/libmodplug-0.8.8.5.tar.gz"
  sha256 "77462d12ee99476c8645cb5511363e3906b88b33a6b54362b4dbc0f39aa2daad"

  bottle do
    cellar :any
    revision 3
    sha256 "b9f6ca27fc558ca74f2349fa00387da79e342d6ac24203e19fc00893384f26fe" => :el_capitan
    sha256 "cc4de1ee20e8b7a058782d695b4673a421ff9ed631de2cd9c1a04d59c1eef3b9" => :yosemite
    sha256 "9a6b215a8c903ac98382b31f36e1d82550bf7166aa7eaf262abb85bd2152bc4f" => :mavericks
  end

  resource "testmod" do
    # Most favourited song on modarchive:
    # https://modarchive.org/index.php?request=view_by_moduleid&query=60395
    url "https://api.modarchive.org/downloads.php?moduleid=60395#2ND_PM.S3M"
    sha256 "f80735b77123cc7e02c4dad6ce8197bfefcb8748b164a66ffecd206cc4b63d97"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    # First a basic test just that we can link on the library
    # and call an initialization method.
    (testpath/"test_null.cpp").write <<-EOS.undent
      #include "libmodplug/modplug.h"
      int main() {
        ModPlugFile* f = ModPlug_Load((void*)0, 0);
        if (!f) {
          // Expecting a null pointer, as no data supplied.
          return 0;
        } else {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test_null.cpp", "-lmodplug", "-o", "test_null"
    system "./test_null"

    # Second, acquire an actual music file from a popular internet
    # source and attempt to parse it.
    resource("testmod").stage testpath
    (testpath/"test_mod.cpp").write <<-EOS.undent
      #include "libmodplug/modplug.h"
      #include <fstream>
      #include <sstream>

      int main() {
        std::ifstream in("downloads.php");
        std::stringstream buffer;
        buffer << in.rdbuf();
        int length = buffer.tellp();
        ModPlugFile* f = ModPlug_Load(buffer.str().c_str(), length);
        if (f) {
          // Expecting success
          return 0;
        } else {
          return -1;
        }
      }
    EOS
    system ENV.cc, "test_mod.cpp", "-lmodplug", "-lstdc++", "-o", "test_mod"
    system "./test_mod"
  end
end
