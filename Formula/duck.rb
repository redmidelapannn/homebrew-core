class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh//duck-src-6.0.1.24918.tar.gz"
  sha256 "c24304ef9ab48dcd7c0b10fd38bbc3045d684b29ec74221bc57f225b00b4ee93"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "c90985d1d3fb8f8cb38bc993ed6cf84eed9f98ab33e76cea74f75f6263efe1a8" => :sierra
    sha256 "fe53a87ee0a1969a72ce6600b21e731181502342a73dc9dc02f1ac0f684c92f7" => :el_capitan
    sha256 "edb093e6b861c000d5e406142db778fd19ae9cf75feb9fd7900aee1441fb0c84" => :yosemite
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
