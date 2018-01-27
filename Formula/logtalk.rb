class Logtalk < Formula
  desc "Object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3140stable.tar.gz"
  version "3.14.0"
  sha256 "53308f726616e5c6ea1ff76c26c08a3e402a32aaa7f8a6f7fbd59828441ee390"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a6f8af68576a25f38b434c687e9f271161a5bf780e1a3f62600c771824824181" => :high_sierra
    sha256 "7e4b99dc06384b6077147920888e820df1f0be54a4a1c053fd611af965951964" => :sierra
    sha256 "d5c14d6abbc0d1d07c5ead1e79eb40242fb413d1f1d364f9c54cabddbda8cdb0" => :el_capitan
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
