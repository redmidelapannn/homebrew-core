class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.2.0.tar.gz"
  sha256 "836caddb30ad5972a453269b027f614d51b5fd2f751a0fe63cfeb0be7388a8e9"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "f12768e77fb25f00f2bd7117cebfc5982d6b7546c528cdeedd4e3887aa548666" => :sierra
    sha256 "f12768e77fb25f00f2bd7117cebfc5982d6b7546c528cdeedd4e3887aa548666" => :el_capitan
    sha256 "9707014b6ed035229f4fd5e7bf58b68aa8c4323da6a6e26066c7069aa7d08da3" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.2.1-beta.2.tar.gz"
    sha256 "9074c1ba26992f3d3911ee718a34761d313018d0f2055b6f40ba42d0792e6110"
    version "1.2.1-beta.2"
  end

  depends_on "pkg-config" => [:recommended, :run]
  depends_on "dmd" => :build

  def install
    ENV["GITVER"] = version.to_s
    system "./build.sh"
    bin.install "bin/dub"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dub --version")
  end
end
