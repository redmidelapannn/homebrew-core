class Duti < Formula
  desc "Select default apps for documents and URL schemes on OS X"
  homepage "https://github.com/moretension/duti/"
  url "https://github.com/moretension/duti/archive/duti-1.5.3.tar.gz"
  sha256 "0e71b7398e01aedf9dde0ffe7fd5389cfe82aafae38c078240780e12a445b9fa"
  head "https://github.com/moretension/duti.git"

  bottle do
    cellar :any_skip_relocation
    revision 3
    sha256 "730b61c8ba8f778f9be7e6e836c711824ccd97bed322705a94f6283ee41f900f" => :el_capitan
    sha256 "18a6af2c9b00be81b4441fbeb2be074f7a3165ec4809ea29b7353bc5d313691e" => :yosemite
    sha256 "60f6fad4c106ee46657c947db03689973d6d1b1b48f34f11dcced6d0b540c6d1" => :mavericks
  end

  depends_on "autoconf" => :build

  # Add hardcoded SDK path for El Capitan or later.
  # See https://github.com/moretension/duti/pull/20.
  if MacOS.version >= :el_capitan
    patch do
      url "https://github.com/moretension/duti/pull/20.patch"
      sha256 "8fab50d10242f8ebc4be10e9a9e11d3daf91331d438d06f692fb6ebd6cbec2f8"
    end
  end

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/duti", "-x", "txt"
  end
end
