class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.13-20171207.tar.gz"
  version "0.13"
  sha256 "26e642456caab38aa9459279b9712ffec52f751e9f46641d28461c244bd6bae6"

  bottle do
    cellar :any
    sha256 "e388d42659f550536fc59446d08ded04b1e88c8f841ab06f2de83c34f6bc1b30" => :high_sierra
    sha256 "6f2680d87d1ce57ac5b9ab59e15dee6a304b2cd071c4ded131b2f1bdef13d823" => :sierra
    sha256 "349195c9d8da5b060e2e8085cec3b6646b6798dc6d4e89d9a4c9d98a88352a9d" => :el_capitan
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
