class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "http://htmlcleaner.sourceforge.net/index.php"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.16/htmlcleaner-2.16-src.zip"
  sha256 "8b9066ebdaff85b15b3cb29208549227ca49351b4bd01779ea8cb3de6f4aac7e"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "fc8bbc81b9354529a3845145b741fa5591c47ca6b99a6313110cea28d8d8f926" => :el_capitan
    sha256 "100a6ca9ec9a4c0739af893b94af177e06715bc717e66799070ea64185f93834" => :yosemite
    sha256 "cbdab944017bc3a86789bfa56207d811ee239a050860807defe348e4666dd2d4" => :mavericks
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
