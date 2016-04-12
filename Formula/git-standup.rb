class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/1.0.0.tar.gz"
  sha256 "fd3808fb8414308413248b2f47646f51ce7bf7a6b59beb257fbde2e983b60127"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9baa81b5311bc72c451bcf96991678316203439f976efb9e798690088539c748" => :el_capitan
    sha256 "2864fa383cf98ce5aba239d7e77083e0f89f97e6bdb92c75a16adb7dcd9067a4" => :yosemite
    sha256 "a2bd8ab5233cd40cbf352e43a76a9332d18326490199e4618c553b994b69c411" => :mavericks
  end

  def install
    bin.install "git-standup"
  end

  test do
    system "git", "standup", "--help"
  end
end
