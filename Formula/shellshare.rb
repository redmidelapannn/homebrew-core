class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/v1.0.0.tar.gz"
  sha256 "72bd49928982611ae44aac4a308dc6054d9c8ebad87644bd5eb68ff0bb704ce3"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e8b682b866614ee795f93fa44c3e6ec1887c248b0a9d35a1263c1cd71ee6993" => :sierra
    sha256 "7e8b682b866614ee795f93fa44c3e6ec1887c248b0a9d35a1263c1cd71ee6993" => :el_capitan
    sha256 "7e8b682b866614ee795f93fa44c3e6ec1887c248b0a9d35a1263c1cd71ee6993" => :yosemite
  end

  depends_on :python

  def install
    bin.install "public/bin/shellshare"
  end

  test do
    system "#{bin}/shellshare", "-v"
  end
end
