class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "http://omniorb.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.1/omniORB-4.2.1-2.tar.bz2"
  sha256 "9b638c7047a05551c42fe13901194e63b58750d4124654bfa26203d09cb5072d"

  bottle do
    revision 1
    sha256 "cec9454b461eeb9cc47125d91d19f736592b633324c2558ffc457fd2fd300658" => :el_capitan
    sha256 "0ffb2cc491903c44b121f89cb00b5a88c80196bf1e9ae27289734de38a1116b5" => :yosemite
    sha256 "51f04995fb43aa606a4cdd8f3321812719b046819fa0c0590ef6172267354a92" => :mavericks
  end

  depends_on "pkg-config" => :build

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.1/omniORBpy-4.2.1-2.tar.bz2"
    sha256 "e0d0f89c0fc6e33b480a2bf7acc7d353b9346a7067571a6be8f594c78b161422"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
  end
end
