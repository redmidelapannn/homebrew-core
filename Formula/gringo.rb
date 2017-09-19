class Gringo < Formula
  desc "Grounder to translate user-provided logic programs"
  homepage "https://potassco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/potassco/gringo/4.5.4/gringo-4.5.4-source.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/gringo/gringo-4.5.4-source.tar.gz"
  sha256 "81f8bbbb1b06236778028e5f1b8627ee38a712ec708724112fb08aecf9bc649a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a67fbf56f7eeb179c2ada159e6f724bae4cdc1280391adcb40f5b62fcc0740db" => :sierra
    sha256 "fdfdabd6e6d8e4febe0699ee25e9fc75754c7da11664576144bacaa1e6d898ea" => :el_capitan
  end

  depends_on "re2c" => :build
  depends_on "scons" => :build
  depends_on "bison" => :build

  needs :cxx11

  def install
    # Allow pre-10.9 clangs to build in C++11 mode
    ENV.libcxx

    system "2to3", "--write", "--fix=print", "SConscript", "SConstruct"

    inreplace "SConstruct",
              "env['CXX']            = 'g++'",
              "env['CXX']            = '#{ENV.cxx}'"

    scons "--build-dir=release", "gringo", "clingo", "reify"
    bin.install "build/release/gringo", "build/release/clingo", "build/release/reify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gringo --version")
  end
end
