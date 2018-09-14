class Irods < Formula
  desc "Integrated data grid software solution"
  homepage "https://irods.org/"
  url "https://github.com/irods/irods-legacy/archive/3.3.1.tar.gz"
  sha256 "e34e7be8646317d5be1c84e680d8f59d50a223ea25a3c9717b6bf7b57df5b9f6"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "0058eb8461592f0686aa03278d2d7f4980215b828ab30874008f409217535f2a" => :mojave
    sha256 "5bbd83f1468dc6bd9fd3d597eb7ed38d94e31ce3f44ee70122c1b545bd3b368b" => :high_sierra
    sha256 "048c05c46472efb64ea0f62ba3943affaf5e74ab6af8f695d610d33acd3377ab" => :sierra
    sha256 "b586ec296ad173f797146c74e93fa9f197f999e98ea2ee098cadf2df5772f73c" => :el_capitan
  end

  depends_on "openssl"

  conflicts_with "sleuthkit", :because => "both install `ils`"
  conflicts_with "renameutils",
    :because => "both install `icp` and `imv` binaries"

  def install
    cd "iRODS" do
      system "./scripts/configure"

      # include PAM authentication by default
      inreplace "config/config.mk", "# PAM_AUTH = 1", "PAM_AUTH = 1"
      inreplace "config/config.mk", "# USE_SSL = 1", "USE_SSL = 1"

      system "make"
      bin.install Dir["clients/icommands/bin/*"].select { |f| File.executable? f }
    end
  end

  test do
    system "#{bin}/ipwd"
  end
end
