class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.1.1.tar.gz"
  sha256 "4c789ee33ecff2b655bc839c5ebc7b20d581f99529f8f553628ed38d9615e553"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "fd820213d6896a87ff52843e456749543cb95433ebc0d1a15ff23ce4586a4185" => :sierra
    sha256 "796680bddbdfa9a66c9ec8d7bf09df9b6d450ace9eb9899460f961f3fba554f6" => :el_capitan
    sha256 "3e5aabb81474821393fb20e09bc4ff23b11d0a05ca26bdaeef75a2d844737c04" => :yosemite
  end

  depends_on "sbt" => :build
  depends_on :java => "1.6+"

  def install
    system "./sbt", "-sbt-jar", Formula["sbt"].opt_libexec/"bin/sbt-launch.jar",
                    "core/assembly"
    libexec.install "wartremover-assembly.jar"
    bin.write_jar_script libexec/"wartremover-assembly.jar", "wartremover"
  end

  test do
    (testpath/"foo").write <<-EOS.undent
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS
    cmd = "#{bin}/wartremover -traverser org.wartremover.warts.Unsafe foo 2>&1"
    assert_match "var is disabled", shell_output(cmd, 1)
  end
end
