class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh//duck-src-6.1.0.25371.tar.gz"
  sha256 "1999068cb3b1e18e2d05cd1d73177e9444c24e7a6cbf3377d8ecd94dd4a3f76e"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    sha256 "8358505eed98269d83666134a73a1fc0c83beea52615d8d9a2569d9a3cfd2f72" => :sierra
    sha256 "1212a8774799b46ad4c9113c1db3d1cd80a22a43ea240db1d7a03df7df930450" => :el_capitan
    sha256 "fa57fa889a2abad8bf91ddcca0d06a77156ef6d8bc46e30f6d08f8ff7403a678" => :yosemite
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
