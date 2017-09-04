class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-6.2.4.26305.tar.gz"
  sha256 "e4daa0314995fef1d3146f2390056babab4ab97b23d4e14823b5480fa23c8be3"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    rebuild 1
    sha256 "23fb5138e2036f77f80e06ddfe329837db8cca044ec01d6cd575ba9c8d4811bd" => :sierra
    sha256 "51fdbf8a3555ca02f6cc85dce413b903cf4f4f30f397ba5389a69b67d82a8109" => :el_capitan
    sha256 "9f4329767d8818f82e2201629c9a5563e335990731a15f53a1928ce3dcb3030e" => :yosemite
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build
  depends_on "maven" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "mvn", "-DskipTests", "-Dgit.commitsCount=#{revision}", "--projects", "cli/osx", "--also-make", "verify"
    libexec.install Dir["cli/osx/target/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["libmagic"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["libmagic"].stable.checksum
  end
end
