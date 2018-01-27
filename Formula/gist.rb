class Gist < Formula
  desc "Command-line utility for uploading Gists"
  homepage "https://github.com/defunkt/gist"
  url "https://github.com/defunkt/gist/archive/v4.6.2.tar.gz"
  sha256 "149a57ba7e8a8751d6a55dc652ce3cf0af28580f142f2adb97d1ceeccb8df3ad"
  head "https://github.com/defunkt/gist.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ad0b34a19d359cb7600b351b3ea4ad4944c77db52d3ca9582606d4b881c52497" => :high_sierra
    sha256 "ad0b34a19d359cb7600b351b3ea4ad4944c77db52d3ca9582606d4b881c52497" => :sierra
    sha256 "ad0b34a19d359cb7600b351b3ea4ad4944c77db52d3ca9582606d4b881c52497" => :el_capitan
  end

  def install
    system "rake", "install", "prefix=#{prefix}"
  end

  test do
    assert_match %r{https:\/\/gist}, pipe_output("#{bin}/gist", "homebrew")
  end
end
