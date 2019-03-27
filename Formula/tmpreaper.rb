class Tmpreaper < Formula
  desc "Clean up files in directories based on their age"
  homepage "https://packages.debian.org/sid/tmpreaper"
  url "https://deb.debian.org/debian/pool/main/t/tmpreaper/tmpreaper_1.6.13+nmu1.tar.gz"
  version "1.6.13_nmu1"
  sha256 "c88f05b5d995b9544edb7aaf36ac5ce55c6fac2a4c21444e5dba655ad310b738"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "0aba3f9f1e0070c9a3c735da1cb8106d84b0619b1510cc69ac228af909bb972f" => :mojave
    sha256 "6a1e0a6d5f6bdb1ef864abb568ae61717d767eb927b5299fefa9dc7f0e789e65" => :high_sierra
    sha256 "ae35050e4a3d6db8abe9521de625d7a9213da3fc9e3e3c29a1d06b49e827d8e4" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    touch "removed"
    sleep 3
    touch "not-removed"
    system "#{sbin}/tmpreaper", "2s", "."
    refute_predicate testpath/"removed", :exist?
    assert_predicate testpath/"not-removed", :exist?
  end
end
