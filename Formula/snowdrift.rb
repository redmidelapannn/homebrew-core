class Snowdrift < Formula
  desc "App to perform testing and validation of firewall rules"
  homepage "https://comcast.github.io/"
  url "https://github.com/Comcast/snowdrift/archive/snowdrift-1.0.tar.gz"
  sha256 "f48b6beec8f6f93d1e57709f6ff8853352ccea7e21e28b53f9a31dacd3e27e96"

  bottle do
    cellar :any_skip_relocation
    sha256 "60fe9121b6b3ae93c4385ff8274d7e66267a5cc3653a5d30459bd4197e5fafce" => :high_sierra
    sha256 "60fe9121b6b3ae93c4385ff8274d7e66267a5cc3653a5d30459bd4197e5fafce" => :sierra
    sha256 "60fe9121b6b3ae93c4385ff8274d7e66267a5cc3653a5d30459bd4197e5fafce" => :el_capitan
  end

  def install
    bin.install "snowdrift"
  end

  test do
    #
    # Not quite sure where there is to test here....
    #
    system "true"
  end
end
