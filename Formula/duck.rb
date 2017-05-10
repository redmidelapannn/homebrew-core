class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.0.0.24625.tar.gz"
  sha256 "ea9ac134fa3146822fced3da34f56154616993008707e74e8fc0733e7617425e"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    rebuild 1
    sha256 "92cfc7a978f67ae9b5b398528a279ec523417a67a3fb372f8de21138a915491f" => :sierra
    sha256 "7eacbf7e435ca6c5f0fb77e394cb17eb47a5fbef089c20bf8de0fd164688e924" => :el_capitan
    sha256 "ddabfc9f9e353fbfb77e281819401b845814fb0800a5952d6524850f1184d4af" => :yosemite
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
    ENV.java_cache
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}", "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["wget"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["wget"].stable.checksum
  end
end
