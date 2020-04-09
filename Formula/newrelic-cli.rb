class NewrelicCli < Formula
  desc "The New Relic Command-line Interface"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.6.2.tar.gz"
  sha256 "603bf5b23e8f986085596b0728503eaa46d41cb31d1c3ac9f1988ac7d48219ec"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e966236b723360d51f54d95837878870e0010f01e685a2368a3a470f9df4daf" => :catalina
    sha256 "679a2f88d9d75a952dc427a2087b8f26a24cf6034351370c74342677baaf7086" => :mojave
    sha256 "06d45c75627ac960cfda511c99a099f51e99f085dc7504b57639481117ce5d17" => :high_sierra
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
