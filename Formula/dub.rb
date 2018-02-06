class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.7.1.tar.gz"
  sha256 "baa8c533f59d83f74e89c06f5ec7e52daf3becb227c7177a9eeab7159ba86dbc"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "24f00c58fa72f542ed26f498ce87476f37caadb50ca35d8012c53282983bc7c0" => :high_sierra
    sha256 "e4f8413530cc02f619788016cbaf54befc698b654696d0fd6ac4d54258807c0c" => :sierra
    sha256 "d71adbc969e4ba3baa53951a8d4867fb28ac1902bed68c26cd7d78e6ae9dceac" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.7.2-beta.1.tar.gz"
    sha256 "5f1f9a4f59bee5721b7e6f49a87c49732908743f0c0f30b31a746fca26b16489"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version").split(/[ ,]/)[2]
  end
end
