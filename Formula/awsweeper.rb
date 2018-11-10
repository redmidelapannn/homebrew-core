class Awsweeper < Formula
  desc "AWSweeper is a tool to clean out your AWS account"
  homepage "https://github.com/cloudetc"
  version "0.2.0"
  url "https://github.com/cloudetc/awsweeper/releases/download/v#{version}/awsweeper_#{version}_darwin_amd64.tar.gz"
  sha256 "21c725ef4a4dc60df46a441e8eb4edf60bfc3ebc17d7b018152da6f2d081f827"

  bottle do
    cellar :any_skip_relocation
    sha256 "85b0e2180d17869fab15c0a27f4615c2e8e866309534fca099b088d45529ac14" => :mojave
    sha256 "915c4f854e9f031a21098409b5e1776bde146c19a8211de077b099defc67e597" => :high_sierra
    sha256 "915c4f854e9f031a21098409b5e1776bde146c19a8211de077b099defc67e597" => :sierra
  end

  def install
    bin.install "awsweeper"
  end

  test do
    assert_match "0.1.1", shell_output("#{bin}/awsweeper --version ")
  end
end
