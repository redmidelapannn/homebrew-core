class Duti < Formula
  desc "Select default apps for documents and URL schemes on macOS"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.4.tar.gz"
  sha256 "3f8f599899a0c3b85549190417e4433502f97e332ce96cd8fa95c0a9adbe56de"
  head "https://github.com/moretension/duti.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "f9abbd8f15e81228d50344ffbd65ca087b3cf80ff8ac8ecd5ddfbfe0d4175e22" => :mojave
    sha256 "e5e6504518bca16a5b8811c57460e18adc7dd0ec294eb16cf6e3e78abcd3248b" => :high_sierra
    sha256 "391870c7cfb3905333e9ddff69c0596e9958e95c4d41a4c761d8fccf7fcf9828" => :sierra
  end

  depends_on "autoconf" => :build

  # Fix compilation on macOS 10.14 Mojave
  patch do
    url "https://github.com/moretension/duti/pull/32.patch?full_index=1"
    sha256 "0f6013b156b79aa498881f951172bcd1ceac53807c061f95c5252a8d6df2a21a"
  end

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "com.apple.TextEdit", shell_output("#{bin}/duti -l public.text"),
                 "TextEdit not found among the handlers for public.text"
  end
end
