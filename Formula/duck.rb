class Duck < Formula
  desc "Command-line interface for Cyberduck (a multi-protocol file transfer tool)"
  homepage "https://duck.sh/"
  # check the changelog for the latest stable version: https://cyberduck.io/changelog/
  url "https://dist.duck.sh/duck-src-4.8.18316.tar.gz"
  sha256 "d48c209a65b587143fc3b8e98290edbe6e354c6ea710c095507e5be7ddb0f048"
  head "https://svn.cyberduck.io/trunk/"

  bottle do
    cellar :any
    sha256 "6ea5b811ad1ce815f76d244e0b4d78559686909f0bb4e85f93bca32a75672da5" => :el_capitan
    sha256 "f22edd5f40375e21b558b6d0043d055c2ef842a939aec130a5c86abd27cc5cf6" => :yosemite
    sha256 "d81bee6f17c7ed1ef22d0f30d3448939d3ad3db058819897ce50cf4ae9dc798d" => :mavericks
  end

  depends_on :java => ["1.8+", :build]
  depends_on :xcode => :build
  depends_on "ant" => :build

  def install
    revision = version.to_s.rpartition(".").last
    system "ant", "-Dbuild.compile.target=1.8", "-Drevision=#{revision}", "cli"
    libexec.install Dir["build/duck.bundle/*"]
    bin.install_symlink "#{libexec}/Contents/MacOS/duck" => "duck"
  end

  test do
    system "#{bin}/duck", "--download", Formula["wget"].stable.url, testpath/"test"
    (testpath/"test").verify_checksum Formula["wget"].stable.checksum
  end
end
