class Librtlsdr < Formula
  desc "Use Realtek DVT-T dongles as a cheap SDR"
  homepage "https://sdr.osmocom.org/trac/wiki/rtl-sdr"
  url "https://github.com/steve-m/librtlsdr/archive/v0.5.3.tar.gz"
  sha256 "98fb5c34ac94d6f2235a0bb41a08f8bed7949e1d1b91ea57a7c1110191ea58de"
  head "git://git.osmocom.org/rtl-sdr.git", :shallow => false

  bottle do
    cellar :any
    rebuild 2
    sha256 "cb5d3ca762d9b50d294415da04414301716ee8bc8c6a119981acea9885c505cc" => :sierra
    sha256 "3fda36e6c69cf2557c0f0f395fe6e360a7144dd7c98ad7769afd21bfb3521af5" => :el_capitan
    sha256 "68f7a617da24bf54f0bfef91c09c7d7d44a8449d35a80d69fc0e6a23ef74030f" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "libusb"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
