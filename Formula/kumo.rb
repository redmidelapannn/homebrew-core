class Kumo < Formula
  desc "Word Clouds in Java"
  homepage "https://github.com/kennycason/kumo"
  url "https://search.maven.org/remotecontent?filepath=com/kennycason/kumo-cli/1.13/kumo-cli-1.13.jar"
  sha256 "c9ad525f7d6aec9e2c06cf10017e1e533f43b1b3c4df5aa0d4b137f8d563c5c6"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b6eeac48729586927f672f956d8c1ad28d91040aac94f3991c92a318e95995d" => :high_sierra
    sha256 "c9238742ee7c0f645b6f478526c593e0e6b6a3f34c015488c8116ed0a4c596f6" => :sierra
    sha256 "79aeb2c8b6d25fa41ee6aeccf1e75d06771144fdd63aeb2f29b5d2c8377b05d2" => :el_capitan
  end

  depends_on :java => "1.8+"

  def install
    libexec.install "kumo-cli-#{version}.jar"
    bin.write_jar_script libexec/"kumo-cli-#{version}.jar", "kumo"
  end

  test do
    system bin/"kumo", "-i", "https://wikipedia.org", "-o", testpath/"wikipedia.png"
    assert_predicate testpath/"wikipedia.png", :exist?, "Wordcloud was not generated!"
  end
end
