class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.18/libsecret-0.18.5.tar.xz"
  sha256 "9ce7bd8dd5831f2786c935d82638ac428fa085057cc6780aba0e39375887ccb3"

  bottle do
    sha256 "4ca9203ff665cf1da698aafb9815e508a14383da77acc762bb61d598ac9b9ad0" => :el_capitan
    sha256 "8c0724930059d4d2144edf6766fd6d1c598ac337f5c6520d426666597f6a0a2e" => :yosemite
    sha256 "06d20cac84cd9235954ab2a5890ec2e8431209497b3089d8062c6a1c1d23e7a6" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-sed" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "docbook-xsl" => :build
  depends_on "vala" => :optional
  depends_on "gobject-introspection" => :recommended
  depends_on "glib"
  depends_on "libgcrypt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-gobject-introspection" if build.with? "gobject-introspection"
    args << "--enable-vala" if build.with? "vala"

    system "./configure", *args

    # https://bugzilla.gnome.org/show_bug.cgi?id=734630
    inreplace "Makefile", "sed", "gsed"

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
