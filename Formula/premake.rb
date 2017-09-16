class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://downloads.sourceforge.net/project/premake/Premake/4.4/premake-4.4-beta5-src.zip"
  sha256 "0fa1ed02c5229d931e87995123cdb11d44fcc8bd99bba8e8bb1bbc0aaa798161"
  version_scheme 1
  head "https://github.com/premake/premake-core.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "678419e3d2f10e0240c930a070146fea0a570b3f0852e7eea83b965a95d5f5dd" => :high_sierra
    sha256 "4596c6bf0ef2faad0750248592dc25ca9273b8840a5d0ed54ddfa8a1597f662d" => :sierra
    sha256 "3a1344f7a02b88b6bb09eccaa7b793374b7939adf119c584ce6813b246993687" => :el_capitan
  end

  devel do
    url "https://github.com/premake/premake-core/releases/download/v5.0.0-alpha12/premake-5.0.0-alpha12-src.zip"
    sha256 "5fa4a9f5b100024e23e2b9117ffa4935a6ac3c0a61aa027c3211388d53536751"
  end

  def install
    if build.head?
      system "make", "-f", "Bootstrap.mak", "osx"
      system "./premake5", "gmake"
    end

    system "make", "-C", "build/gmake.macosx"

    if build.devel? || build.head?
      bin.install "bin/release/premake5"
    else
      bin.install "bin/release/premake4"
    end
  end

  test do
    if stable?
      assert_match version.to_s, shell_output("#{bin}/premake4 --version", 1)
    else
      assert_match version.to_s, shell_output("#{bin}/premake5 --version")
    end
  end
end
