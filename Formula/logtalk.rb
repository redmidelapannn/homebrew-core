class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3180stable.tar.gz"
  version "3.18.0"
  sha256 "88b0bd2d426eec6add81580002c1709efc3c4b3423121d19587c03ab4cafec85"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c829356909d28b1e319c82c719968c8fd337296420da444c40d57ec9708a29a" => :high_sierra
    sha256 "fc162b0e9276bb7234567038391660f3b9525018598e7fadce4aa222ccfac8ec" => :sierra
    sha256 "06378fc69a618c038e855baa522b9ef6d7d1032502919b1a5f92049a25e5b933" => :el_capitan
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
