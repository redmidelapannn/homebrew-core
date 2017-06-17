class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/wartremover/wartremover"
  url "https://github.com/wartremover/wartremover/archive/v2.1.1.tar.gz"
  sha256 "4c789ee33ecff2b655bc839c5ebc7b20d581f99529f8f553628ed38d9615e553"
  head "https://github.com/wartremover/wartremover.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3733f084e123ca14eedb41c9affc9971c018a21705856c28150aeecbf73517cf" => :sierra
    sha256 "1cb2d0f1f8fb5ad51ebb0aaa8d50475c41f64b1ccf551d3a61619033e96b6c4c" => :el_capitan
    sha256 "1cb2d0f1f8fb5ad51ebb0aaa8d50475c41f64b1ccf551d3a61619033e96b6c4c" => :yosemite
  end

  depends_on "sbt" => :build

  def install
    # Prevents sandbox violation
    ENV.java_cache
    system "sbt", "core/assembly"
    libexec.install Dir["core/target/scala-*/wartremover-assembly-*.jar"]
    bin.write_jar_script Dir[libexec/"wartremover-assembly-*.jar"][0], "wartremover"
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
