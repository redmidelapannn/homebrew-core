class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-5.4.0.23761.tar.gz"
  sha256 "4a2048151dfaea66f439874c89a4ae67ce3e20cf169300707eb1042990c18086"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "9c26f43d53d498873e07b076e4e2d1582a7d7fb7aebecd4277c48f877ad3f2ae" => :sierra
    sha256 "357282a2d6092927a8dd133e9868646dffab55b339376280b8476d19cf7db6b8" => :el_capitan
    sha256 "fb45a7ae70bbf69a247563591deb6b5f8a305f4a2bf073bd216c4567cd6e3864" => :yosemite
    sha256 "6aaab98af32f261163510703ea45f15aeedc38fb81af648952a294ddf96c438a" => :mavericks
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
    ENV.java_cache
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}", "--projects", "cli/osx", "--also-make", "package"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["wget"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["wget"].stable.checksum
  end
end
