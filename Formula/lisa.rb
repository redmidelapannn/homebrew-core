class Lisa < Formula
  desc "Starting a file system watcher then execute a command."
  homepage "http://miclle.me/lisa/"
  url "https://github.com/miclle/lisa/files/255510/v0.1.0.tar.gz"
  sha256 "a296aa36c915988796a421841785d4ea1d2cd45379655fcbac29f80c01b24a4c"

  bottle do
    sha256 "48020c18dd91b3bf01cc295a016e7e504848ca0b184f32e2007e6a6fe053e687" => :el_capitan
    sha256 "58d36b8d9c8fc6f78396bcd65185a2e35392a18786e0fc746e78b0712d570eaa" => :yosemite
    sha256 "bb06fd8ced6c8b2080b0cb9f83f14fe30623ee2b7c9f14001900fc97336bcbbd" => :mavericks
  end

  def install
    libexec.install "lisa"

    chmod 0755, "#{libexec}/lisa"

    bin.install_symlink libexec/"lisa"
  end

  test do
    system bin/"lisa", "--help"
  end
end
