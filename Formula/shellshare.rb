class Shellshare < Formula
  desc "LIVE TERMINAL BROADCAST"
  homepage "http://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/v1.0.0.tar.gz"
  sha256 "72bd49928982611ae44aac4a308dc6054d9c8ebad87644bd5eb68ff0bb704ce3"
  def install
    bin.install "public/bin/shellshare"
  end
  test do
  end
end
