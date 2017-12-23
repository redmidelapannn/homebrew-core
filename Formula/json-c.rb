class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.13-20171207.tar.gz"
  version "0.13"
  sha256 "26e642456caab38aa9459279b9712ffec52f751e9f46641d28461c244bd6bae6"

  bottle do
    cellar :any
    sha256 "0ec0e1e15ddfb6b7aa7e9b6f4bd3e330dfc3fef60b8405ed6ecc93ede6b29ec9" => :high_sierra
    sha256 "540ba3e6b407892baf44cd0df015530d2afd13390e9ead2d9b8c999337916014" => :sierra
    sha256 "180559246fabd2fa9e5a6909ed4383c20f8297c185324ddab88d055734c5ffbd" => :el_capitan
  end

  head do
    url "https://github.com/json-c/json-c.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <json-c/json.h>

      int main() {
        json_object *obj = json_object_new_object();
        json_object *value = json_object_new_string("value");
        json_object_object_add(obj, "key", value);
        printf("%s\n", json_object_to_json_string(obj));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ljson-c", "test.c", "-o", "test"
    assert_equal '{ "key": "value" }', shell_output("./test").chomp
  end
end
