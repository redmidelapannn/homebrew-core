class Gringo < Formula
  desc "Grounder to translate user-provided logic programs"
  homepage "https://potassco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/potassco/gringo/4.5.4/gringo-4.5.4-source.tar.gz"
  mirror "https://www.mirrorservice.org/sites/distfiles.macports.org/gringo/gringo-4.5.4-source.tar.gz"
  sha256 "81f8bbbb1b06236778028e5f1b8627ee38a712ec708724112fb08aecf9bc649a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "24ba1e1829a2b85ecdb8fee8f4e52f88b2c166fe994a9ea9cef3e68b650623ee" => :sierra
    sha256 "c1b8433a4246dc35b184bed5093099490b0f2da036d3138b1783f463064a5c33" => :el_capitan
    sha256 "fa03a0999b75991b182ad66b93bc0a3177515ad89c6e68aaa15f43257f69e36d" => :yosemite
  end

  depends_on "re2c" => :build
  depends_on "scons" => :build
  depends_on "bison" => :build

  needs :cxx11

  def install
    # Allow pre-10.9 clangs to build in C++11 mode
    ENV.libcxx

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
