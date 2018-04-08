class Mimms < Formula
  include Language::Python::Virtualenv

  desc "Mms stream downloader"
  homepage "https://savannah.nongnu.org/projects/mimms"
  url "https://launchpad.net/mimms/trunk/3.2.1/+download/mimms-3.2.1.tar.bz2"
  sha256 "92cd3e1800d8bd637268274196f6baec0d95aa8e709714093dd96ba8893c2354"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "c3c0e0f3129d1755ae2114efa2e9edb9e86adf2f326005d1816b23a3183b1372" => :high_sierra
    sha256 "0e9deb9e54b6b488fc0ca08dc1b0a7e3e2f703d42951b8abaa315b48b2a78c2f" => :sierra
    sha256 "e3180cfcdfeffb0f6a246e05cf66a88cb63afe0630fb869a30a12de70657a955" => :el_capitan
  end

  depends_on "python@2"
  depends_on "libmms"

  # Switch shared library loading to Mach-O naming convention (.dylib)
  # Matching upstream bug report: https://savannah.nongnu.org/bugs/?29684
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/mimms", "--version"
  end
end

__END__
diff --git a/libmimms/libmms.py b/libmimms/libmms.py
index fb59207..ac42ba4 100644
--- a/libmimms/libmms.py
+++ b/libmimms/libmms.py
@@ -23,7 +23,7 @@ exposes the mmsx interface, since this one is the most flexible.
 
 from ctypes import *
 
-libmms = cdll.LoadLibrary("libmms.so.0")
+libmms = cdll.LoadLibrary("libmms.0.dylib")
 
 # opening and closing the stream
 libmms.mmsx_connect.argtypes = [c_void_p, c_void_p, c_char_p, c_int]
