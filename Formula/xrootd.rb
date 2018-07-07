class Xrootd < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "http://xrootd.org"
  url "http://xrootd.org/download/v4.8.4/xrootd-4.8.4.tar.gz"
  sha256 "f148d55b16525567c0f893edf9bb2975f7c09f87f0599463e19e1b456a9d95ba"
  head "https://github.com/xrootd/xrootd.git"

  bottle do
    cellar :any
    sha256 "d9c1fa3cfe71e691c90ece299eaac13e8add4458480b8da6b72926fc4d9bec2c" => :high_sierra
    sha256 "54266f85884d3cbbab18f73df9653d35f943d700f04e922771c8124c6d93ab9e" => :sierra
    sha256 "3c19f981344b5f788c4725c5aabd37c2dffc6bac7187e673d979a764c30a83a6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
