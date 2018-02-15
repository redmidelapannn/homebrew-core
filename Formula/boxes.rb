class Boxes < Formula
  desc "Draw boxes around text"
  homepage "https://boxes.thomasjensen.com/"
  url "https://github.com/ascii-boxes/boxes/archive/v1.2.tar.gz"
  sha256 "ba237f6d4936bdace133d5f370674fd4c63bf0d767999a104bada6460c5d1913"
  head "https://github.com/ascii-boxes/boxes.git"

  bottle do
    rebuild 1
    sha256 "4cd18bcce309444fb8f7edda976feef73b83fc3365fe96c3b99b8de7d2a64a89" => :high_sierra
    sha256 "88da3a1188a5fd1a7af226a6c0706d7eb7b2eee830a32cedba3ec98f5dcf3dea" => :sierra
    sha256 "7674409339e12c9e0d788ff7a8037d5c09dc457aa8549acc7243cbfec075df7e" => :el_capitan
  end

  def install
    # distro uses /usr/share/boxes change to prefix
    system "make", "GLOBALCONF=#{share}/boxes-config", "CC=#{ENV.cc}"

    bin.install "src/boxes"
    man1.install "doc/boxes.1"
    share.install "boxes-config"
  end

  test do
    assert_match "test brew", pipe_output("#{bin}/boxes", "test brew")
  end
end
