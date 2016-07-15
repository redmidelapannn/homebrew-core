class CKermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "http://www.kermitproject.org/"
  url "http://www.kermitproject.org/ftp/kermit/archives/cku302.tar.gz"
  version "9.0.302"
  sha256 "0d5f2cd12bdab9401b4c836854ebbf241675051875557783c332a6a40dac0711"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "c2c97f91949551491a73baec7c8a21f39d0fbbdce95f2c81282744cc8a6dc04e" => :el_capitan
    sha256 "f27a7c72741156d8b7fad0a15ad52c7743d521db2985c5ceb18943619ee5db77" => :yosemite
    sha256 "f89c8f8979623bd6b219df0bcce39527fbb75261efe985f8c29503e26a150211" => :mavericks
  end

  def install
    system "make", "macosx"
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    assert_match "C-Kermit #{version}",
                 shell_output("#{bin}/kermit -C VERSION,exit")
  end
end
