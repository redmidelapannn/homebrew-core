class Htmlcleaner < Formula
  desc "HTML parser written in Java"
  homepage "https://htmlcleaner.sourceforge.io"
  url "https://downloads.sourceforge.net/project/htmlcleaner/htmlcleaner/htmlcleaner%20v2.18/htmlcleaner-2.18-src.zip"
  sha256 "d16250d038b5adc2a343fb322827575ddca95ba84887be659733bf753e7ef15b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d2cbdddc13b57fbff068e7e18c6eaa8fa9b08f2fde47b8b8c4e8f9ac03467b7c" => :sierra
    sha256 "c34a368e31f4bb6f4fd95b79059afcd7418d6cd818939efaa9bbb7d8b6ba1943" => :el_capitan
    sha256 "4520b6862f9476df2ec82ecfaac0ea08f87538d83c4902bdd1a4bbbc841fc194" => :yosemite
  end

  depends_on "maven" => :build
  depends_on :java => "1.8+"

  def install
    system "mvn", "--log-file", "build-output.log", "clean", "package"
    libexec.install Dir["target/htmlcleaner-*.jar"]
    bin.write_jar_script "#{libexec}/htmlcleaner-#{version}.jar", "htmlcleaner"
  end

  test do
    path = testpath/"index.html"
    path.write "<html>"
    assert_match "</html>", shell_output("#{bin}/htmlcleaner src=#{path}")
  end
end
