class NotmuchAddressCache < Formula
  desc "notmuch-address-cache is basically a cache in front of the notmuch-address command."
  homepage "https://github.com/mbauhardt/notmuch-address-cache"
  url "https://github.com/mbauhardt/notmuch-address-cache/archive/0.1.tar.gz"
  sha256 "db43c114184f402c9baba20215f0cf57cc83b4701f034b96f0511b3c81463088"


  bottle do
    cellar :any_skip_relocation
    sha256 "8ab34015963ff8df58ca1fe5aca05c50186dffe07527178ccf8676742fb16080" => :high_sierra
    sha256 "8ab34015963ff8df58ca1fe5aca05c50186dffe07527178ccf8676742fb16080" => :sierra
    sha256 "8ab34015963ff8df58ca1fe5aca05c50186dffe07527178ccf8676742fb16080" => :el_capitan
  end

  def install
    bin.install "bin/notmuch-address-cache"
    man.mkpath
    man1.install "share/man/man1/notmuch-address-cache.1"
  end

end
