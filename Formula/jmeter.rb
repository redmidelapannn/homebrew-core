class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-5.2.1.tgz"
  sha256 "bbb3cb5fe0b16c1fa139727063f18d9aca6890c7edf53f3a614b8f929f1f1de9"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b2e3f8f4e25726fee621ff70602919e148d44dac32e6c5dae9eda9673e08f1b7" => :catalina
    sha256 "b2e3f8f4e25726fee621ff70602919e148d44dac32e6c5dae9eda9673e08f1b7" => :mojave
    sha256 "b2e3f8f4e25726fee621ff70602919e148d44dac32e6c5dae9eda9673e08f1b7" => :high_sierra
  end

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar"
    sha256 "482b8a9cd82a69ef1b633fc4235bfa9bee96894f663e5085df7061410d6ab99a"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jmeter"

    resource("jmeter-plugins-manager").stage do
      (libexec/"lib/ext").install Dir["*"]
    end
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
