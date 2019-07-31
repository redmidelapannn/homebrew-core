class Kash < Formula
  desc "Shell powered by Kotlin"
  homepage "https://github.com/cbeust/kash"
  url "https://github.com/cbeust/kash/archive/v1.9.tar.gz"
  sha256 "59211d1844f83416faed5fb388670d909793099bf4e195791651b46df2b097b1"

  def install
    system "./gradlew", "assemble"
    libexec.install "build/libs/kash-1.9.jar"
    bin.write_jar_script libexec/"kash-1.9.jar", "kash", :java_version => "11.0"
  end

  test do
    assert_equal "pong", shell_output("#{bin}/kash --ping").strip
  end
end
