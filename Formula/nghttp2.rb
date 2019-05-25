class Nghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.38.0/nghttp2-1.38.0.tar.xz"
  sha256 "ef75c761858241c6b4372fa6397aa0481a984b84b7b07c4ec7dc2d7b9eee87f8"

  bottle do
    rebuild 1
    sha256 "0e60f331ee753e335521a4cc16bc22eb52bceb775b2f306b14b321c17bcf0dad" => :mojave
    sha256 "182fb5f0d4e8d650323cae75524546a1bb7fdd5db2455a05db1cc9a2a6bb3b6f" => :high_sierra
    sha256 "4ff29da557fb054dce2ac0ec60f78b24497ad5e6f6dea6445fb8acb1c49a1372" => :sierra
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "cunit" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "c-ares"
  depends_on "jansson"
  depends_on "jemalloc"
  depends_on "libev"
  depends_on "libevent"
  depends_on "openssl"

  patch :DATA

  def install
    ENV.cxx11

    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --enable-app
      --disable-python-bindings
      --with-xml-prefix=/usr
    ]

    # requires thread-local storage features only available in 10.11+
    args << "--disable-threads" if MacOS.version < :el_capitan

    system "autoreconf", "-ivf" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"nghttp", "-nv", "https://nghttp2.org"
  end
end

__END__
diff --git a/src/shrpx_client_handler.cc b/src/shrpx_client_handler.cc
index 6266c5f..3c5946e 100644
--- a/src/shrpx_client_handler.cc
+++ b/src/shrpx_client_handler.cc
@@ -994,7 +994,7 @@ ClientHandler::get_downstream_connection(int &err, Downstream *downstream) {
   auto http2session = get_http2_session(group, addr);
   auto dconn = std::make_unique<Http2DownstreamConnection>(http2session);
   dconn->set_client_handler(this);
-  return dconn;
+  return std::move(dconn);
 }
 
 MemchunkPool *ClientHandler::get_mcpool() { return worker_->get_mcpool(); }

