class SentryCli < Formula
  desc "This is a Sentry command-line client for some generic tasks."
  homepage "https://github.com/getsentry/sentry-cli"
  url "https://github.com/getsentry/sentry-cli/releases/download/0.24.0/sentry-cli-Darwin-x86_64"
  version "0.24.0"
  sha256 "eac9c2d127111b6c6036ab1596a8fe4d186d6feb52d95a433d9018f9c288e5ca"

  bottle do
    cellar :any_skip_relocation
    sha256 "25eed701fa769c708926bc53a533f6a5da4aad1fd89308e3b71ec3e51ce46e57" => :sierra
    sha256 "25eed701fa769c708926bc53a533f6a5da4aad1fd89308e3b71ec3e51ce46e57" => :el_capitan
    sha256 "25eed701fa769c708926bc53a533f6a5da4aad1fd89308e3b71ec3e51ce46e57" => :yosemite
  end

  def install
    mv "sentry-cli-Darwin-x86_64", "sentry-cli"
    bin.install "sentry-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sentry-cli --version").chomp
  end
end
