class Irods < Formula
  desc "Integrated data grid software solution"
  homepage "https://irods.org/"
  url "https://github.com/irods/irods-legacy/archive/3.3.1.tar.gz"
  sha256 "e34e7be8646317d5be1c84e680d8f59d50a223ea25a3c9717b6bf7b57df5b9f6"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "4fd3ac799aac34f2d022f10ba23f1498133a9a7d9f4158dee959cb00eda46cfe" => :sierra
    sha256 "c826d085c7480b528e952258e2319141ecc5052ee55d833df39a6f50bccbfa93" => :el_capitan
    sha256 "a9a2f57a29c4bb6cf11a0e597c25b6ee9869c9e4a5f98a972d67f0ce36ab0244" => :yosemite
  end

  option "with-osxfuse", "Install iRODS FUSE client"

  depends_on :osxfuse => :optional
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
