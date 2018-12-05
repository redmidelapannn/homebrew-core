class AardvarkShellUtils < Formula
  desc "Utilities to aid shell scripts or command-line users"
  homepage "http://www.laffeycomputer.com/shellutils.html"
  url "https://web.archive.org/web/20170106105512/downloads.laffeycomputer.com/current_builds/shellutils/aardvark_shell_utils-1.0.tar.gz"
  sha256 "aa2b83d9eea416aa31dd1ce9b04054be1a504e60e46426225543476c0ebc3f67"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0e335a27f4c3cf6503de76522e6843ec8cde28c0d62ec62c22cda2442eeac490" => :mojave
    sha256 "85ea95f7678817a48b3d6bb7949136a5fc678a03beda2f60a9c3efef68156068" => :high_sierra
    sha256 "533c14b27333dd0909de8af74407e7b09a69ec5ca9eaa53e727fe2a3b4610a23" => :sierra
  end

  conflicts_with "coreutils", :because => "both install `realpath` binaries"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "movcpm", shell_output("#{bin}/filebase movcpm.com").strip
    assert_equal "com", shell_output("#{bin}/fileext movcpm.com").strip
    assert_equal testpath.realpath.to_s, shell_output("#{bin}/realpath .").strip
  end
end
