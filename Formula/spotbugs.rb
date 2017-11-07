class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs' successor)"
  homepage "https://spotbugs.github.io/"
  url "https://github.com/spotbugs/spotbugs/archive/3.1.0.tar.gz"
  sha256 "ac6169a551212756a05dd9c066ef9212653d8a99b754ef4dade6a7008f8ad781"
  head "https://github.com/spotbugs/spotbugs.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "72b2801333a1557c0f6c2e796cafa14781fa0ffdfc472e81db31225350a110ce" => :high_sierra
    sha256 "698de9229339f56e6800ca88f79a72c3b5bb4ac1395392cbf2b4fd6f1975e02a" => :sierra
    sha256 "a5b9ebb540f663e95e9fcf1e3bada98b434222b54f0025bf3aa3dd5ac6d0324b" => :el_capitan
  end

  depends_on "gradle" => :build
  depends_on :java => "1.8+"

  def install
    system "gradle", "build"
    system "gradle", "installDist"
    libexec.install Dir["spotbugs/build/install/spotbugs/*"]
    bin.install_symlink "#{libexec}/bin/spotbugs"
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      public class HelloWorld {
        private double[] myList;
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
        public double[] getList() {
          return myList;
        }
      }
    EOS
    system "javac", "HelloWorld.java"
    system "jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    assert_match /M V EI.*\nM C UwF.*\n/, shell_output("#{bin}/spotbugs -textui HelloWorld.jar")
  end
end
