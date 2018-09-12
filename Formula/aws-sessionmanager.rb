class AwsSessionmanager < Formula
  desc "Session Manager Plugin for the AWS CLI"
  homepage "https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with.html"
  url "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/mac/sessionmanager-bundle.zip"
  version "1.0.0.0"
  sha256 "a68e716f618937e6671b1f01b1a7c2b986457a21c0274426effba8383e15c042"

  bottle do
    cellar :any_skip_relocation
    sha256 "4ff37854ac7929dc9f166586d9e72de8d295f96c83a8b87831033e1c0ef606fc" => :mojave
    sha256 "89130b75c4e5ffe3aeaf7d10303dccd37ad74b3ec76385694902ddb7b4a592bb" => :high_sierra
    sha256 "89130b75c4e5ffe3aeaf7d10303dccd37ad74b3ec76385694902ddb7b4a592bb" => :sierra
    sha256 "89130b75c4e5ffe3aeaf7d10303dccd37ad74b3ec76385694902ddb7b4a592bb" => :el_capitan
  end

  depends_on "python"

  def install
    bin.install "bin/session-manager-plugin"
    prefix.install_metafiles
    prefix.install "VERSION"
  end

  test do
    system "#{bin}/session-manager-plugin"
  end
end
