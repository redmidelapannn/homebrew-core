class GoogleJavaFormat < Formula
  desc "Reformats Java source code to comply with Google Java Style."
  homepage "https://github.com/google/google-java-format"
  url "https://github.com/google/google-java-format/archive/google-java-format-1.4.tar.gz"
  sha256 "e3c78d87830d6727bb36554371cd03f7756ee3018fcec97ef022738cc7851c98"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "79470509ea210b255976b054b231f5cab75a1b2ec42e578a02c6477a67c38e3e" => :sierra
    sha256 "6e9add82d238e691b4a7a39c46d51ea7092c8a48bda1d81840139c5493c0a058" => :el_capitan
    sha256 "de040d0e19d063d23e492bbb4d99305a057ae47437a0e9ea398a6811ff92549a" => :yosemite
  end

  depends_on "maven" => :build

  def install
    system "mvn", "install", "-DskipTests=true", "-Dmaven.javadoc.skip=true", "-B"
    libexec.install "core/target/google-java-format-#{version}-all-deps.jar"

    bin.write_jar_script libexec/"google-java-format-#{version}-all-deps.jar", "google-java-format"
  end

  test do
    (testpath/"foo.java").write "public class Foo{\n}\n"
    assert_match "public class Foo {}", shell_output("#{bin}/google-java-format foo.java")
  end
end
