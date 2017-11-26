class LibatomicOps < Formula
  desc "Implementations for atomic memory update operations"
  homepage "https://github.com/ivmai/libatomic_ops/"
  url "https://github.com/ivmai/libatomic_ops/releases/download/v7.4.8/libatomic_ops-7.4.8.tar.gz"
  sha256 "c405d5524b118c197499bc311b8ebe18f7fe47fc820f2c2fcefde1753fbd436a"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ab36c4b220c7c6e5175c7bfca66d393022ebbf82c62fd0b88ac24a65f7754219" => :high_sierra
    sha256 "3b6a4a87d9dc8dbb3ea38c3aa8bbebbd7a48e73d6f35d9a2bac4e83f014377ca" => :sierra
    sha256 "1aea728c40cbd116f8843a12b6c61b1e15261e936efa34516e57f193b86fcbaf" => :el_capitan
  end

  devel do
    url "https://github.com/ivmai/libatomic_ops/releases/download/v7.6.0/libatomic_ops-7.6.0.tar.gz"
    sha256 "8e2c06d1d7a05339aae2ddceff7ac54552854c1cbf2bb34c06eca7974476d40f"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
