class Clockywock < Formula
  desc "Ncurses analog clock"
  homepage "https://soomka.com/"
  url "https://soomka.com/clockywock-0.3.1a.tar.gz"
  sha256 "278c01e0adf650b21878e593b84b3594b21b296d601ee0f73330126715a4cce4"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0b190fc5f68ab633f6e731836df8a05ce3b41ef4a0924355d6ef9f29bc4b5b21" => :sierra
    sha256 "3fe9dc2248698771b4472dd0ca4c172d75cad5fb7fd7e85dc777753392b0085c" => :el_capitan
    sha256 "c081b6554469f94c037cf5e044a8ee2e93d8fac1494d4dbe9a8eebf92c461338" => :yosemite
  end

  def install
    system "make"
    bin.install "clockywock"
    man7.install "clockywock.7"
  end

  test do
    system "#{bin}/clockywock", "-h"
  end
end
