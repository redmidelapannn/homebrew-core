class LeelaZero < Formula
  desc "Neural Network Go engine with no human-provided knowledge"
  homepage "http://zero.sjeng.org/"
  url "https://github.com/gcp/leela-zero/archive/v0.15.tar.gz"
  sha256 "6a34df356cf64aaa74bdf90826f8653255c42c3e65da8715f9c39751de00926a"

  bottle do
    cellar :any
    sha256 "b7bdcab5c59fcb775cf1d484406524dc353d31cb1b3895de5d5096dd8b423f23" => :high_sierra
    sha256 "c9fca12935a1997256cd1ec68d972adaa46b93bffeaac03293c74753b88b2318" => :sierra
    sha256 "f705b8f80b1b469c3188fbc04c60fbbee63673e1eb05982832b92f3b34bee3ef" => :el_capitan
  end

  option "without-network", "Don't automatically download the best known network"

  depends_on "boost"

  resource "network" do
    url "http://zero.sjeng.org/best-network", :using => :nounzip
  end

  def install
    cd "src" do
      system "make"
      bin.install "leelaz"
    end

    pkgshare.install resource("network") if build.with? "network"
  end

  def caveats
    return if build.without?("network")
    <<~EOS
      This formula also downloads the currently best-trained set of network
      weights. They are stored in #{opt_pkgshare}/best-network

      To use this network, pass the `-w <path>` parameter to leelaz.
    EOS
  end

  test do
    system "#{bin}/leelaz", "--help"
  end
end
