class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.6.1.tar.gz"
  sha256 "d910dc8ff0898ee7ebf64f1f326d16c0e47cf02b4d79168617daa06f86aa2af2"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bfb236b3a1b7147481c51cc56e868f44d83745ee4a1953439149f1d64415bb3" => :catalina
    sha256 "2a7c54c2303d09887281e62f382ae551dcc696204d162b26149c44ce2fe5d320" => :mojave
    sha256 "363fce6e312fd421af054bc4d1a5e620104d5912a76453fe2920f93a1753b83c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/darwin/newrelic"

    output = Utils.popen_read("#{bin}/newrelic completion --shell bash")
    (bash_completion/"newrelic").write output
    output = Utils.popen_read("#{bin}/newrelic completion --shell zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    assert_match /pluginDir/, shell_output("#{bin}/newrelic config list")
    assert_match /logLevel/, shell_output("#{bin}/newrelic config list")
    assert_match /sendUsageData/, shell_output("#{bin}/newrelic config list")
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
