class Bup < Formula
  desc "Backup tool"
  homepage "https://github.com/bup/bup"
  url "https://github.com/bup/bup.git",
    :tag => "0.28",
    :revision => "017af24d11d45541dd20d48568588650cc5ed598"

  head "https://github.com/bup/bup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf639b7c9d23840a5300a35c54931979600f37a0da8d086830ceffa2b9e42066" => :el_capitan
    sha256 "d668522c0696bc9bb600366192849bf5e85e2914004722171bf5d77f54951cba" => :yosemite
    sha256 "b74dd0cd23946c06c8e95789ae9c000e28db2cd932f422172e23b11f9fc5befc" => :mavericks
  end

  patch :DATA

  option "with-pandoc", "Build and install the manpages"
  option "with-test", "Run unit tests after compilation"
  option "without-web", "Build without repository access via `bup web`"

  deprecated_option "run-tests" => "with-test"
  deprecated_option "with-tests" => "with-test"

  depends_on "pandoc" => [:optional, :build]
  depends_on :python if MacOS.version <= :snow_leopard

  resource "backports_abc" do
    url "https://pypi.python.org/packages/source/b/backports_abc/backports_abc-0.4.tar.gz"
    sha256 "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5"
  end

  resource "backports.ssl-match-hostname" do
    url "https://pypi.python.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "certifi" do
    url "https://pypi.python.org/packages/source/c/certifi/certifi-2016.2.28.tar.gz"
    sha256 "5e8eccf95924658c97b990b50552addb64f55e1e3dfe4880456ac1f287dc79d0"
  end

  resource "singledispatch" do
    url "https://pypi.python.org/packages/source/s/singledispatch/singledispatch-3.4.0.3.tar.gz"
    sha256 "5b06af87df13818d14f08a028e42f566640aef80805c3b50c5056b086e3c2b9c"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "tornado" do
    url "https://pypi.python.org/packages/source/t/tornado/tornado-4.3.tar.gz"
    sha256 "c9c2d32593d16eedf2cec1b6a41893626a2649b40b21ca9c4cac4243bde2efbf"
  end

  def install
    if build.with? "web"
      ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(libexec/"vendor")
        end
      end
    end

    system "make"
    system "make", "test" if build.bottle? || build.with?("test")
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end

  test do
    system bin/"bup", "init"
    assert File.exist?("#{testpath}/.bup")
  end
end

__END__
diff --git a/cmd/web-cmd.py b/cmd/web-cmd.py
index 4add17c..2a90525 100755
--- a/cmd/web-cmd.py
+++ b/cmd/web-cmd.py
@@ -6,7 +6,7 @@ exec "$bup_python" "$0" ${1+"$@"}
 # end of bup preamble
 
 from collections import namedtuple
-import mimetypes, os, posixpath, signal, stat, sys, time, urllib, webbrowser
+import mimetypes, os, posixpath, signal, stat, sys, time, unicodedata, urllib, webbrowser
 
 from bup import options, git, vfs
 from bup.helpers import (chunkyreader, debug1, handle_ctrl_c, log,
@@ -100,7 +100,7 @@ class BupRequestHandler(tornado.web.RequestHandler):
         path = urllib.unquote(path)
         print 'Handling request for %s' % path
         try:
-            n = top.resolve(path)
+            n = top.resolve(unicodedata.normalize('NFD', unicode(path, "utf-8")).encode("utf-8"))
         except vfs.NoSuchFile:
             self.send_error(404)
             return
