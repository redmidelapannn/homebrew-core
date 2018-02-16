class Detekt < Formula
  desc "Static code analysis for Kotlin"
  homepage "https://github.com/arturbosch/detekt"
  url "https://github.com/arturbosch/detekt/archive/RC6-3.tar.gz"
  sha256 "aeff12326240ca76d9a1d72eec2d66d1e6cc3ac906937706ab37babd96ab9b9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "f1b37646d882984bd032c15dcfdb060a5c59b49b5fb3f94ad183717c012e8fc0" => :high_sierra
    sha256 "ac92976f81e4597c28fed7d1821b2238aec1536e6f230705e2dbd280459a1d57" => :sierra
    sha256 "b13fc1e6ae1a5aa0145dd448d335d0350f8a806171d1858fb9a526ffe3da89fb" => :el_capitan
  end

  depends_on :java => "1.8"

  def install
    system "./gradlew", "build", "shadowJar"
    libexec.install "detekt-cli/build/libs/detekt-cli-1.0.0.RC6-3-all.jar"
    (libexec/"bin").write_jar_script libexec/"detekt-cli-1.0.0.RC6-3-all.jar", "detekt"
    (libexec/"bin/detekt").chmod 0755
    (bin/"detekt").write_env_script libexec/"bin/detekt", Language::Java.java_home_env("1.8")
  end
  test do
    system bin/"detekt", "--help"
  end
end
