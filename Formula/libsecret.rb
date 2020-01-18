class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.20/libsecret-0.20.0.tar.xz"
  sha256 "f1187370b453106af878e30c284a121ba0c513da8bb4170b329d66e250bdae43"

  bottle do
    sha256 "b5dff1a72ca91a7cb916e17970dd1b31fe39a3a95a6f748ed4815368d014fe9a" => :catalina
    sha256 "a21ea46864771587b62b617532eb0b05ee834344ba7df4ad847972546038f934" => :mojave
    sha256 "57d690a5f575228e66e666e5ba3e1367ba55e6a9cbf288158e70396588f8d1f1" => :high_sierra
    sha256 "75dfd997940eff3f732760f0a654d4030d3a644d49a134f2fc27b823292859cf" => :sierra
  end

  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "libgcrypt"

  patch do
    url "https://gitlab.gnome.org/GNOME/libsecret/commit/cf21ad50b62f7c8e4b22ef374f0a73290a99bdb8.patch"
    sha256 "e46be298953abdd0e161c933250dbc7aed042d62371850e0c33f164ced92ddfd"
  end

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-introspection
      --enable-vala
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsecret/secret.h>

      const SecretSchema * example_get_schema (void) G_GNUC_CONST;

      const SecretSchema *
      example_get_schema (void)
      {
          static const SecretSchema the_schema = {
              "org.example.Password", SECRET_SCHEMA_NONE,
              {
                  {  "number", SECRET_SCHEMA_ATTRIBUTE_INTEGER },
                  {  "string", SECRET_SCHEMA_ATTRIBUTE_STRING },
                  {  "even", SECRET_SCHEMA_ATTRIBUTE_BOOLEAN },
                  {  "NULL", 0 },
              }
          };
          return &the_schema;
      }

      int main()
      {
          example_get_schema();
          return 0;
      }
    EOS

    flags = [
      "-I#{include}/libsecret-1",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
