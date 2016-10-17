class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/about"
  url "https://github.com/dlang/dub.git",
      :tag => "v1.0.0",
      :revision => "b59af2b8befb4fad4157d8c9cc86dba707b2fc87"

  head "https://github.com/dlang/dub.git", :shallow => false

  bottle do
    rebuild 1
    sha256 "f913f7638177cdd717d4aefbdbd9326c3aaeb71b5573f490f0bd53411394dd41" => :sierra
    sha256 "f913f7638177cdd717d4aefbdbd9326c3aaeb71b5573f490f0bd53411394dd41" => :el_capitan
    sha256 "1e5de16d56222640e0cc521497de0ec4e004b6911f179ccddfadcbed8ddfd794" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub.git",
        :tag => "v1.1.0-beta.1",
        :revision => "1824d16056a680fcca52d3ce87fb43d3679ff3ee"
  end

  depends_on "pkg-config" => :build
  depends_on "dmd" => :build

  def install
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    system "#{bin}/dub; true"
  end
end
