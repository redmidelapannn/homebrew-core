class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-5.2.1.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.2.1.tgz"
  sha256 "bbb3cb5fe0b16c1fa139727063f18d9aca6890c7edf53f3a614b8f929f1f1de9"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "da4850580db77895c6b473f64b46b7f5fb7910a5a73171cc054c17e4ac56963b" => :catalina
    sha256 "da4850580db77895c6b473f64b46b7f5fb7910a5a73171cc054c17e4ac56963b" => :mojave
    sha256 "da4850580db77895c6b473f64b46b7f5fb7910a5a73171cc054c17e4ac56963b" => :high_sierra
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
