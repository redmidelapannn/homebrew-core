class Irods < Formula
  desc "Integrated data grid software solution"
  homepage "https://irods.org/"
  url "https://github.com/irods/irods-legacy/archive/3.3.1.tar.gz"
  sha256 "e34e7be8646317d5be1c84e680d8f59d50a223ea25a3c9717b6bf7b57df5b9f6"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "8f44971bf908d7f366d35803f34217a3861e37b3af8d79b2658fb119b856717c" => :sierra
    sha256 "c94bd6e8d8d8c5ea5c1608337f24c13027e407b8b5bfebf125c9e138d20ad3cd" => :el_capitan
    sha256 "e573560c07969f1115f8621aa6fc61c3751b29a017a8f649f45e0f6da6a3b524" => :yosemite
  end

  conflicts_with "sleuthkit", :because => "both install `ils`"

  option "with-osxfuse", "Install iRODS FUSE client"

  depends_on :osxfuse => :optional
  depends_on "openssl"

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

      # patch in order to use osxfuse
      if build.with? "osxfuse"
        inreplace "config/config.mk" do |s|
          s.gsub! "# IRODS_FS = 1", "IRODS_FS = 1"
          s.gsub! "fuseHomeDir=/home/mwan/adil/fuse-2.7.0", "fuseHomeDir=#{HOMEBREW_PREFIX}"
        end
        inreplace "clients/fuse/Makefile" do |s|
          s.gsub! "lfuse", "losxfuse"
          s.gsub! "-I$(fuseHomeDir)/include", "-I$(fuseHomeDir)/include/osxfuse"
        end

        system "make", "-C", "clients/fuse"
        bin.install Dir["clients/fuse/bin/*"].select { |f| File.executable? f }
      end
    end
  end

  test do
    system "#{bin}/ipwd"
  end
end
