class Bashdb < Formula
  desc "Bash shell debugger"
  homepage "https://bashdb.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bashdb/bashdb/4.4-0.92/bashdb-4.4-0.92.tar.bz2"
  version "4.4-0.92"
  sha256 "6a8c2655e04339b954731a0cb0d9910e2878e45b2fc08fe469b93e4f2dbaaf92"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b9ef81cdf45a642ec2f6ff1bfb22dba7948928fb59a2d5207fabae98bb41272d" => :sierra
    sha256 "b9ef81cdf45a642ec2f6ff1bfb22dba7948928fb59a2d5207fabae98bb41272d" => :el_capitan
    sha256 "b9ef81cdf45a642ec2f6ff1bfb22dba7948928fb59a2d5207fabae98bb41272d" => :yosemite
  end

  depends_on "bash"
  depends_on :macos => :mountain_lion

  def install
    system "./configure", "--with-bash=#{HOMEBREW_PREFIX}/bin/bash",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bashdb --version 2>&1")
  end
end
