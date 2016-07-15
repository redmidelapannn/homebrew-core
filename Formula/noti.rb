class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.2.0.tar.gz"
  sha256 "3acb1cb0c352e6387b172867e5187f9241b66f9104d95c93ad8dc9a908937626"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "fde6455c5e938633062e1262a1b24b0fb6499789f932a9c5e0b630ed41ca37e1" => :el_capitan
    sha256 "16f75e03a970c5242aed6d36bf6217692babbc2f25ba596c16430cc12d58f466" => :yosemite
    sha256 "e4f8df9a7dc8c30d3e32eb5445742f7cbd7ee0aec1246f24ef03613b12343527" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    notipath = buildpath/"src/github.com/variadico/noti"
    notipath.install Dir["*"]

    cd "src/github.com/variadico/noti/cmd/noti" do
      system "go", "build"
      bin.install "noti"
    end
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
