class Httpflow < Formula
  desc "Packet capture and analysis utility similar to tcpdump for HTTP Edit"
  homepage "https://github.com/six-ddc/httpflow/releases"
  url "https://github.com/six-ddc/httpflow/archive/0.0.3.tar.gz"
  sha256 "26e8d1f8d6c0742b552bc333edd340dc3b3e3ad4590fe2e0e125d830142f0b37"
  head "https://github.com/six-ddc/httpflow.git", :branch => "master"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9d2728c720a1a3d636b51d1cf38b5dfa8a8d0f9029ad8fc3afc3edd89879aa4" => :sierra
    sha256 "c071f055f07a258299a8a4db772d06145e9cbe63bf19e389151d628a0e55477a" => :el_capitan
    sha256 "881ad882f906d0e6433a434662cb6badeb2ed096ce45e583fafcdffd69eb926d" => :yosemite
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
