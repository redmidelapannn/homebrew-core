class Monero < Formula
  desc "Secure, private, untraceable cryptocurrency"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      :tag => "v0.12.0.0",
      :revision => "c29890c2c03f7f24aa4970b3ebbfe2dbb95b24eb"

  bottle do
    sha256 "ed7d01e28bd8d25e7171c0d83be68b48856a0fa81de1e31ca5e25b0a659d0c2d" => :high_sierra
    sha256 "b6ed3b9f4a9a2cc0acb6081f57c630e7cdbcc5a2ca513304766e4031a848feb9" => :sierra
    sha256 "0032bacd0303ab31ac6ed609fdf5979d3c5089dcbda4748f26395f9559cd4c64" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "readline"
  depends_on "zeromq"

  resource "cppzmq" do
    url "https://raw.githubusercontent.com/zeromq/cppzmq/7a8cc9d7cf448b8fd654ec4cd24fd48b57a76162/zmq.hpp"
    sha256 "eeccec908d78bc195d093fb05a37271b3f7a62ec65b026b6f0b8d801d9b966da"
  end

  def install
    resource("cppzmq").stage include.to_s

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
