class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP"
  homepage "https://github.com/six-ddc/httpflow/releases"
  url "https://github.com/six-ddc/httpflow/archive/0.0.3.tar.gz"
  sha256 "26e8d1f8d6c0742b552bc333edd340dc3b3e3ad4590fe2e0e125d830142f0b37"
  head "https://github.com/six-ddc/httpflow.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0a8db96f19458739b5281a275c2932706053885a10f5f0de399ad4501bd5d7a" => :sierra
    sha256 "3f6a2e93af7d383e3020188846847df6926ab6b418786a438495b67b87eba94a" => :el_capitan
    sha256 "876ab4264d0244337fa42b4c31d1e1336285434d10f4922cf14a5bb4807f0c03" => :yosemite
  end

  def install
    args = %W[
      PREFIX=#{prefix}
      CXX=#{ENV.cxx}
    ]

    system "make"
    system "make", "install", *args
  end

  test do
    system "#{bin}/httpflow", "-h"
  end
end
