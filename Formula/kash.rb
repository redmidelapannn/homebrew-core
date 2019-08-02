class Kash < Formula
  desc "Shell powered by Kotlin"
  homepage "https://github.com/cbeust/kash"
  version "1.11"
  url "https://github.com/cbeust/kash/archive/v#{version}.tar.gz"
  sha256 "74d5ab5f7b464e36164e360558d628c8bf934818fe1358b0b0bdde112ce0b057"

  depends_on :java

  def install
    system "./gradlew", "assemble"
    libexec.install "build/libs/kash-#{version}.jar"
    bin.write_jar_script libexec/"kash-#{version}.jar", "kash", :java_version => "11.0"
  end

  test do
    assert_equal "pong", shell_output("#{bin}/kash --ping").strip
  end
end
