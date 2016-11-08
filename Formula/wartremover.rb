class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  head "https://github.com/puffnfresh/wartremover.git"

  stable do
    url "https://github.com/puffnfresh/wartremover/archive/v1.2.0.tar.gz"
    sha256 "882994c1890139f81adbd74902bbc445b3865102441c1055acf18bb6c1675f3d"

    patch do
      url "https://github.com/puffnfresh/wartremover/commit/e914d91.patch"
      sha256 "33d360baa204fa5720f25e96b058246619143416dd87d081ceee3774c2231baf"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8eefdab0c310eeeadbbeb361f7aa219cd51a2e8b9a2da297bb75db2cc6ab41bc" => :sierra
    sha256 "59e9f4484188577e45d67ff595824b16bba320ee3c86b0a12838e071b880f6ee" => :el_capitan
    sha256 "1e066888053dac542693d6a22a7ae1fc0f88595355b821f136ede44cebb99ff1" => :yosemite
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
