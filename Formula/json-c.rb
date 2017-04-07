class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/json-c-0.12-20140410.tar.gz"
  version "0.12"
  sha256 "99304a4a633f1ee281d6a521155a182824dd995139d5ed6ee5c93093c281092b"

  bottle do
    cellar :any
    rebuild 2
    sha256 "4f902fff0b5399f81513d9801adf5a34bcec38220631aa15b9cc10552783bc5e" => :sierra
    sha256 "4af90950ff1e227ae977de5dc6b1fa178b22c5d1e0c82f0255dc16bb104d1586" => :el_capitan
    sha256 "cfd4f936885063f1dc4507a5c5fb0c01f5fbc3f8396c2b66d3a3a349874ffa49" => :yosemite
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
    (testpath/"test.c").write <<-'EOS'.undent
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
