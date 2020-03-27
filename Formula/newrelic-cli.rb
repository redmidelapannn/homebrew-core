class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.5.0.tar.gz"
  sha256 "11e99b789383d7a45d10c30766c9bebb84104b767290c1f80755737ea75b6a48"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7334c6638da4eea52f46b31c82d9812d3de1c91beb220a682f81c4d8bc768469" => :catalina
    sha256 "d40842d9702eee6e5dfa521303e2938766af891a4729f7196d52a73137f34ffb" => :mojave
    sha256 "215dd6bb3bdb785df8c8d8fdc87640d73835b216fdfe1c0d284e91bc8c604611" => :high_sierra
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
