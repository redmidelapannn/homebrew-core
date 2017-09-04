class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-267.tar.gz"
  sha256 "5898bcc02e45a5fbc7b38af7ba6788d8a85f55e54285a668848c2064138aa9ea"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1a333577a90c40937af54275f0661d1ff4a349ddec0625370b86fdd477edcc65" => :sierra
    sha256 "cbd8310d5beab28a6f910f991d7b68d3f6b711fca8234a6608accda19652ecb1" => :el_capitan
    sha256 "43526167024aec20ac8f1650926d404f54f21547beb93843cdd36a7f53e5b60c" => :yosemite
  end

  depends_on :java => "1.6+"
  depends_on "maven" => :build

  def install
    system "mvn", "package", "-DskipTests=true",
                             "-Dmaven.javadoc.skip=true",
                             "-Dcobertura.skip=true"

    cd "jmxtrans" do
      vers = Formula["jmxtrans"].version.to_s.split("-").last
      inreplace "jmxtrans.sh", "lib/jmxtrans-all.jar",
                               libexec/"target/jmxtrans-#{vers}-all.jar"
      chmod 0755, "jmxtrans.sh"
      libexec.install %w[jmxtrans.sh target]
      pkgshare.install %w[bin example.json src tools vagrant]
      doc.install Dir["doc/*"]
    end

    bin.install_symlink libexec/"jmxtrans.sh" => "jmxtrans"
  end

  test do
    output = shell_output("#{bin}/jmxtrans status", 3).chomp
    assert_equal "jmxtrans is not running.", output
  end
end
