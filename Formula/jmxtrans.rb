class Jmxtrans < Formula
  desc "Tool to connect to JVMs and query their attributes"
  homepage "https://github.com/jmxtrans/jmxtrans"
  url "https://github.com/jmxtrans/jmxtrans/archive/jmxtrans-parent-264.tar.gz"
  sha256 "006d723ee1830df474b0e786e310dbe3317c6b4b9649f30fff9d64d314e59cba"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "16f9524eec028110a7f6c4e19dffdc495e00e8d941265886763799a305411437" => :sierra
    sha256 "061639b2f06d3dae64dd73d716765de5d79537244118f8a0c216e978fae4c275" => :el_capitan
    sha256 "6fcdecb97d01191e8bcd0354e6a12ae75363a8de224d8fe944dc93ce0925339f" => :yosemite
  end

  depends_on :java => "1.6+"
  depends_on "maven" => :build

  def install
    ENV.java_cache

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
