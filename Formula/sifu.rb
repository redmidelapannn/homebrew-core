# Documentation: https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Sifu < Formula
  desc "Installation of Sifu tool."
  homepage "https://codesifu.com"
  url "https://codesifu.com/download/sifu-0.1.1.tar.gz"
  version "0.1.1"
  sha256 "d0ef00a475766bf4717b4721044bdbd0f1c8c02be3a1f824738d306b08a06cd2"

  bottle do
    cellar :any_skip_relocation
    sha256 "2861ee1aa8183ae9eb3c636490f8a6ca73d5e41078a70a392fe75da2d6a992e7" => :el_capitan
    sha256 "3330c500f1710382c246a2d5f00ab777f1349ffe79c9ec7c77ef6d834371de28" => :yosemite
    sha256 "3330c500f1710382c246a2d5f00ab777f1349ffe79c9ec7c77ef6d834371de28" => :mavericks
  end

  # depends_on "cmake" => :build
  depends_on :java # if your formula requires any X11/XQuartz components

  def install
    rm_f Dir["*.bat"]
    bin.install Dir["*"]

  end
end
