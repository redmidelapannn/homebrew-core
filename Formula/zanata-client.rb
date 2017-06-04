class ZanataClient < Formula
  desc "Zanata translation system command-line client"
  homepage "http://zanata.org/"
  url "https://search.maven.org/remotecontent?filepath=org/zanata/zanata-cli/4.2.1/zanata-cli-4.2.1-dist.tar.gz"
  sha256 "8052b11d0dcda8262221bd573cae70933e00a5e84336235e7149aabcf8cb61f7"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b766810e38f3f13a7bc6e6b81ec52eb6c98d257e8df5197187cfbc7d809070a" => :sierra
    sha256 "b96fa679ee8303faf387cd14666a4647956efbd06963ace7dfddfa9f04604e8b" => :el_capitan
    sha256 "b96fa679ee8303faf387cd14666a4647956efbd06963ace7dfddfa9f04604e8b" => :yosemite
  end

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    (bin/"zanata-cli").write_env_script libexec/"bin/zanata-cli", Language::Java.java_home_env("1.8+")
    bash_completion.install libexec/"bin/zanata-cli-completion"
  end

  test do
    assert_match /Zanata Java command-line client/, shell_output("#{bin}/zanata-cli --help")
  end
end
