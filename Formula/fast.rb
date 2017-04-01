class Fast < Formula
  desc "Flattening Abstract Syntax Trees"
  homepage "https://github.com/yijunyu/fast"
  url "https://github.com/yijunyu/fast/archive/v0.0.1.tar.gz"
  sha256 "844467051325cee43ba98b52e9512133ec53388153b32339190509b82570a4e9"

  bottle do
    cellar :any
    sha256 "6f47986dee31e0981b2ad5fcbcd5d5c52c561ddc444f67c1941225bb80482ab1" => :sierra
    sha256 "bac17a426c9c8fa4bd9662cc76d7fb69a3530fb80b8b3c4c180e935ba31dfed3" => :el_capitan
    sha256 "08b101af324df0cd54f02a6111507386ad6bdb2ee19bb9c021ed94a66d448fc2" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "flatbuffers" => :build
  depends_on "pkg-config" => :build
  depends_on "protobuf" => :build
  depends_on "srcml"

  def install
    system "cmake", "-G", "Unix Makefiles", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"Hello.java").write <<-EOS

public class Hello {
    public static void main(String args[]) {
        System.out.println("Hello, world!");
    }
}
    EOS

    (testpath/"Hello-result.xml").write <<-EOS
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<unit xmlns="http://www.srcML.org/srcML/src" revision="0.9.5" language="Java" filename="Hello.java">
<class><specifier>public</specifier> class <name>Hello</name> <block>{
    <function><specifier>public</specifier> <specifier>static</specifier> <type><name>void</name></type> <name>main</name><parameter_list>(<parameter><decl><type><name>String</name></type> <name><name>args</name><index>[]</index></name></decl></parameter>)</parameter_list> <block>{
        <expr_stmt><expr><call><name><name>System</name><operator>.</operator><name>out</name><operator>.</operator><name>println</name></name><argument_list>(<argument><expr><literal type="string">"Hello, world!"</literal></expr></argument>)</argument_list></call></expr>;</expr_stmt>
    }</block></function>
}</block></class>
</unit>
    EOS

    (testpath/"Hello-fbs-result.xml").write <<-EOS
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<unit xmlns="http://www.srcML.org/srcML/src" xmlns:java="http://www.srcML.org/srcML/java" revision="0.9.5" language="JAVA" filename="Hello.java"><class><specifier>public</specifier> class <name>Hello</name><block>{
    <function><specifier>public</specifier><specifier>static</specifier><type><name>void</name></type><name>main</name><parameter_list>(<parameter><decl><type><name>String</name></type><name><name>args</name><index>[]</index></name></decl></parameter>)</parameter_list><block>{
        <expr_stmt><expr><call><name><name>System</name><operator>.</operator><name>out</name><operator>.</operator><name>println</name></name><argument_list>(<argument><expr><literal>"Hello, world!"</literal></expr></argument>)</argument_list></call></expr>;</expr_stmt>
    }</block></function>
}</block></class></unit>
    EOS

    (testpath/"Hello-pb-result.xml").write <<-EOS
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<unit xmlns="http://www.srcML.org/srcML/src" xmlns:="http://www.srcML.org/srcML/" revision="0.9.5" language="" filename="Hello.java"><class><specifier>public</specifier> class <name>Hello</name><block>{
    <function><specifier>public</specifier><specifier>static</specifier><type><name>void</name></type><name>main</name><parameter_list>(<parameter><decl><type><name>String</name></type><name><name>args</name><index>[]</index></name></decl></parameter>)</parameter_list><block>{
        <expr_stmt><expr><call><name><name>System</name><operator>.</operator><name>out</name><operator>.</operator><name>println</name></name><argument_list>(<argument><expr><literal type="">"Hello, world!"</literal></expr></argument>)</argument_list></call></expr>;</expr_stmt>
    }</block></function>
}</block></class></unit>
    EOS

    fork do
      exec "#{bin}/srcml", "Hello.java", "-o", "Hello.xml"
      exec "#{bin}/fast", "Hello.xml", "Hello.fbs"
      exec "#{bin}/fast", "Hello.fbs", "Hello-fbs.xml"
      exec "#{bin}/fast", "Hello.xml", "Hello.pb"
      exec "#{bin}/fast", "Hello.pb", "Hello-pb.xml"
      exec "diff", "Hello.xml", "Hello-result.xml"
      exec "diff", "Hello-fbs.xml", "Hello-fbs-result.xml"
      exec "diff", "Hello-pb.xml", "Hello-pb-result.xml"
    end
  end
end
