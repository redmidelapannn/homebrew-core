class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.5.0.tar.gz"
  sha256 "3509f959cc5b34e44adaae586b62ded387ac10031f6c1aaf1cfbb4aae5af37dd"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "61ef7b98600c08581680f9bd257400a0c4e9944ef33f8af8a5001200ee2ee226" => :high_sierra
    sha256 "60a7a393b4bd6403776d33ce5e00fd65e4c810543663b660fa877744c41c005d" => :sierra
    sha256 "452125b6401ad18dba93e89abc9f6694364579201f7aba114ab7535c2f98e32c" => :el_capitan
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.6.0-beta.2.tar.gz"
    sha256 "da1877c7c39a4905bca78083784733bfae59d60c7b665169d87fe2d81651b38f"
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
