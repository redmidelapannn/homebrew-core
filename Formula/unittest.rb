class Unittest < Formula
  desc "C++ Unit Test Framework"
  homepage "https://unittest.red-bean.com/"
  url "https://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz"
  sha256 "9586ef0149b6376da9b5f95a992c7ad1546254381808cddad1f03768974b165f"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "79548f590147d0406ae90062dda925a37bf9bd972c2c5140c2cd06adbe2f9f03" => :mojave
    sha256 "ffda19ea4a5a1ab46c23b7de21819f3845c3a8f980ed3840e7eb2e70714cb8ca" => :high_sierra
    sha256 "828d3fcfc87d9a40bdda5c1285b8ee00a5c5bee0fc2f60a52f9221a9e1ea08ea" => :sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "test/unittesttest"
  end

  test do
    system "#{pkgshare}/unittesttest"
  end
end
