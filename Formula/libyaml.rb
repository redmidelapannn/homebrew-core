class Libyaml < Formula
  desc "YAML Parser"
  homepage "http://pyyaml.org/wiki/LibYAML"
  url "http://pyyaml.org/download/libyaml/yaml-0.1.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/liby/libyaml/libyaml_0.1.7.orig.tar.gz"
  sha256 "8088e457264a98ba451a90b8661fcb4f9d6f478f7265d48322a196cec2480729"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d4f7114d6860fc0e87c6da3518dc9dc3cfe8ebd9cfc379bee801e209b10b641c" => :sierra
    sha256 "6a262d63039225373b9a7057488a01ea44847447dc73447704d6670747094c63" => :el_capitan
    sha256 "9ba8fe076ccaae43b52b9fb26003958b3720b1bf299f47482747d8c11726da94" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <yaml.h>

      int main()
      {
        yaml_parser_t parser;
        yaml_parser_initialize(&parser);
        yaml_parser_delete(&parser);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lyaml", "-o", "test"
    system "./test"
  end
end
