class Dub < Formula
  desc "Build tool for D projects"
  homepage "https://code.dlang.org/getting_started"
  url "https://github.com/dlang/dub/archive/v1.2.1.tar.gz"
  sha256 "e880cf9ca6234f751a53a427eba71b8d5585b6b660d6a489458f638d2ff60554"
  version_scheme 1

  head "https://github.com/dlang/dub.git"

  bottle do
    rebuild 1
    sha256 "2d299f3c5db3e729474dea76b228fb654e3b0dfe05a5551fd350191f470be7eb" => :sierra
    sha256 "2d299f3c5db3e729474dea76b228fb654e3b0dfe05a5551fd350191f470be7eb" => :el_capitan
    sha256 "3b958dbe46f6dc29deb44a5ae109de6b1fd1e7f654a51493ec6db1fda9119e3c" => :yosemite
  end

  devel do
    url "https://github.com/dlang/dub/archive/v1.2.2-beta.1.tar.gz"
    sha256 "16f1de8db0c54b6fe7dc7e5944c6dc0146e9c8e51f38869944ddc778af78e537"
    version "1.2.2-beta.1"
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
