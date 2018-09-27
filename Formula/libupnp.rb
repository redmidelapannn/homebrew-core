class Libupnp < Formula
  desc "Portable UPnP development kit"
  homepage "https://pupnp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pupnp/pupnp/libUPnP%201.6.25/libupnp-1.6.25.tar.bz2"
  sha256 "c5a300b86775435c076d58a79cc0d5a977d76027d2a7d721590729b7f369fa43"

  bottle do
    cellar :any
    rebuild 1
    sha256 "7b7424621001aca58841ce8309bbd87fa7b6aa2931052147438c8f386c012515" => :mojave
    sha256 "5421213b45bfb31774788f27c7e325995c80425c806d1e3dbd1042d2c0a17ef9" => :high_sierra
    sha256 "f854ee6d64f8f4869c083be5012795fb0169d7f8f50e341aa9c95155d8041b27" => :sierra
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-ipv6
    ]

    system "./configure", *args
    system "make", "install"
  end
end
