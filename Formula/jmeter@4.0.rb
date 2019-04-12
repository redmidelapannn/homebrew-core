class JmeterAT40 < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-4.0.tgz"
  sha256 "845b8325726171a991cc13072275ec64b2ce4bbc6fa8e2aa350b2369e27e76b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "74960093fbb383f1cf3359548528a90b4dcee1c5d790f165d7f65d6ba3813fe3" => :mojave
    sha256 "74960093fbb383f1cf3359548528a90b4dcee1c5d790f165d7f65d6ba3813fe3" => :high_sierra
    sha256 "5030c34e8dcfed245401857efc60c7c94bb3fb0d17293437c3f8e75b9f823e10" => :sierra
  end

  keg_only :versioned_formula

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jmeter"
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
