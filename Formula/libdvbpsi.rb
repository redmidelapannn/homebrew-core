class Libdvbpsi < Formula
  desc "Library to decode/generate MPEG TS and DVB PSI tables"
  homepage "https://www.videolan.org/developers/libdvbpsi.html"
  url "https://download.videolan.org/pub/libdvbpsi/1.3.2/libdvbpsi-1.3.2.tar.bz2"
  sha256 "ac4e39f2b9b1e15706ad261fa175a9430344d650a940be9aaf502d4cb683c5fe"

  bottle do
    cellar :any
    sha256 "5085552c11f779dc082d115533d98dd9f3df32c758f30197c9aeaf14fa1269de" => :high_sierra
    sha256 "8f59f8abb62f324c1898be55e219192245eaab01fca96bd1f5e4e5d650d23862" => :sierra
    sha256 "dd6206de7987a2dcc315e36725bf82565e36651c6004d9ede3efbcc3614323b2" => :el_capitan
    sha256 "c85ff88dc9ccb4d9474d78c8b0dce4ee4926d5129bc7bf2b35dac3cbb47dbe06" => :yosemite
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-release"
    system "make", "install"
  end
end
