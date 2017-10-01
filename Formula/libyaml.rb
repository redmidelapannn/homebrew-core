class Libyaml < Formula
  desc "YAML Parser"
  homepage "https://pyyaml.org/wiki/LibYAML"
  url "https://pyyaml.org/download/libyaml/yaml-0.1.7.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/liby/libyaml/libyaml_0.1.7.orig.tar.gz"
  sha256 "8088e457264a98ba451a90b8661fcb4f9d6f478f7265d48322a196cec2480729"

  bottle do
    cellar :any
    rebuild 1
    sha256 "136e5410c95a0ea1adfe9436006121d8b6e397c1791f53ba79cab05c5425009a" => :high_sierra
    sha256 "c80aa2926f222b56785c780980dd91f80822bfa2e5a700f047d5620ca0f323c8" => :sierra
    sha256 "c354acb508f12f0c4f93e696f26d5df6dd2c534dae536eb635a9efe7ae84121f" => :el_capitan
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
    system ENV.cc, "test.c", "-L#{lib}", "-lyaml", "-o", "test"
    system "./test"
  end
end
