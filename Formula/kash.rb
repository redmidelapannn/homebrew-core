class Kash < Formula
  desc "Shell powered by Kotlin"
  homepage "https://github.com/cbeust/kash"
  url "https://github.com/cbeust/kash/archive/v1.11.tar.gz"
  sha256 "74d5ab5f7b464e36164e360558d628c8bf934818fe1358b0b0bdde112ce0b057"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e1d4b72d536d3af74b45dc0dd3d69f45a6d5a3b39e9788fedb15881fcc26cec" => :mojave
    sha256 "2e71547c8e219a07dd25599e4afd3715d06a2def51ea7641791be971dbc3b3d9" => :high_sierra
    sha256 "0b8f65319b5625bfbd710a42e1c170314eba9313feb90aea1639bec31b2d153e" => :sierra
  end

  depends_on :java => "11.0+"

  def install
    system "./gradlew", "assemble"
    libexec.install "build/libs/kash-#{version}.jar"
    bin.write_jar_script libexec/"kash-#{version}.jar", "kash", :java_version => "11.0"
  end

  test do
    assert_equal "pong", shell_output("#{bin}/kash --ping").strip
  end
end
