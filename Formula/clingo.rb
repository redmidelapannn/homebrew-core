class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/releases/download/v5.2.1/clingo-5.2.1-macos-10.9.tar.gz"
  version "5.2.1"
  sha256 "e5bd853e6240192c6fd98de972a48a86d4f1b9df2c34d0bb198c324268ee2cde"

  bottle do
    cellar :any_skip_relocation
    sha256 "c004f970e0e023d0c6de64e30405385bb9306a2ce984533a045a171db374f6f5" => :high_sierra
    sha256 "c004f970e0e023d0c6de64e30405385bb9306a2ce984533a045a171db374f6f5" => :sierra
    sha256 "c004f970e0e023d0c6de64e30405385bb9306a2ce984533a045a171db374f6f5" => :el_capitan
  end

  def install
    bin.install "clasp", "clingo", "clingo-python", "gringo", "gringo-python", "lpconvert", "reify"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clingo --version | head -n 1 | cut -d ' ' -f 3")
  end
end
