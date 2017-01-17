class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.16/htmlcleaner-2.16-src.zip"
  sha256 "8b9066ebdaff85b15b3cb29208549227ca49351b4bd01779ea8cb3de6f4aac7e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2b491c84e678c3086bcf1e844a188d3988aae1644789049021bf65968b080e1f" => :sierra
    sha256 "537ca2628a1d68c7f92267c0f1f9106d2d10dad5e5abcedf950951e9226ae844" => :el_capitan
    sha256 "bf6380321709d92dc11286a3b2a1059df25b13fe4f880b6f7aed7a72027e4fa3" => :yosemite
  end

  depends_on "maven" => :build
  depends_on :java => "1.8+"

  def install
    ENV.java_cache

    system "mvn", "clean", "package"
    libexec.install Dir["target/htmlcleaner-*.jar"]
    bin.write_jar_script "#{libexec}/htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
