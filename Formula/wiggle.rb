class Wiggle < Formula
  desc "Program for applying patches with conflicting changes"
  homepage "http://neil.brown.name/blog/20100324064620"
  url "https://src.fedoraproject.org/repo/pkgs/wiggle/wiggle-1.0.tar.gz/777d8d4c718220063511e82e16275d1b/wiggle-1.0.tar.gz"
  sha256 "44c97b2d47a109c709cdd4181d9ba941fee50dbb64448018b91d4a2fffe69cf2"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d62dec3faa32ba6a9428ddc994b8450b976ee206948b0b50b02270505865282e" => :sierra
    sha256 "9fad64e3d2e5baf6f3668008e382b17ccb6d6433692b3179e717756c711faf80" => :el_capitan
  end

  # All three patches are upstream commits
  patch do
    url "https://github.com/neilbrown/wiggle/commit/16bb4be1c93be24917669d63ab68dd7d77597b63.diff?full_index=1"
    sha256 "f563b5ea76aaa1a66b68466ee2c7bd0bc6f2b648514e790f61e975c52de5d139"
  end

  patch do
    url "https://github.com/neilbrown/wiggle/commit/e010f2ffa78b0e50eff5a9e664f9de27bb790035.diff?full_index=1"
    sha256 "211af1f0bde9729ddaeced23edafa5fc54d871afb243b8f3219a8a47d0f3358e"
  end

  patch do
    url "https://github.com/neilbrown/wiggle/commit/351535d3489f4583a49891726616375e249ab1f3.diff?full_index=1"
    sha256 "c394bd7483205881bffe1b8f51c12fb20e339a615903857dbf5f19e26a250b3d"
  end

  def install
    system "make", "OptDbg=#{ENV.cflags}", "wiggle", "wiggle.man", "test"
    bin.install "wiggle"
    man1.install "wiggle.1"
  end
end
