class Backupninja < Formula
  desc "Backup automation tool"
  homepage "https://labs.riseup.net/code/projects/backupninja"
  url "https://labs.riseup.net/code/attachments/download/275/backupninja-1.0.1.tar.gz"
  sha256 "10fa5dbcd569a082b8164cd30276dd04a238c7190d836bcba006ea3d1235e525"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1111767aa42b0af298aec14fc95186bb80d0dca921b647f944cf2bc08aa6b8e4" => :sierra
    sha256 "1111767aa42b0af298aec14fc95186bb80d0dca921b647f944cf2bc08aa6b8e4" => :el_capitan
    sha256 "1111767aa42b0af298aec14fc95186bb80d0dca921b647f944cf2bc08aa6b8e4" => :yosemite
  end

  depends_on "dialog"
  depends_on "gawk"

  skip_clean "etc/backup.d"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
