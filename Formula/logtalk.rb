class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "http://logtalk.org"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3106stable.tar.gz"
  version "3.10.6"
  sha256 "194b8951e5dd4890c99737d38064e14cf0b72e3af108018efe004fe4f254618b"

  bottle do
    cellar :any_skip_relocation
    sha256 "600cc4520cd9aa901084a97f5474a43f2aff236210fca2a459da3772910f4d80" => :sierra
    sha256 "bd123dfc387178aa40a9cff357893930da0229adb9453fb13b191a08bb32c3cd" => :el_capitan
    sha256 "bd123dfc387178aa40a9cff357893930da0229adb9453fb13b191a08bb32c3cd" => :yosemite
  end

  option "with-swi-prolog", "Build using SWI Prolog as backend"
  option "with-gnu-prolog", "Build using GNU Prolog as backend (Default)"

  deprecated_option "swi-prolog" => "with-swi-prolog"
  deprecated_option "gnu-prolog" => "with-gnu-prolog"

  if build.with? "swi-prolog"
    depends_on "swi-prolog"
  else
    depends_on "gnu-prolog"
  end

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
