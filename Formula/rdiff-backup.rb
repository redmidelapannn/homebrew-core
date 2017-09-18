class RdiffBackup < Formula
  desc "Backs up one directory to another--also works over networks"
  homepage "http://rdiff-backup.nongnu.org/"
  url "https://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.2.8.tar.gz"
  sha256 "0d91a85b40949116fa8aaf15da165c34a2d15449b3cbe01c8026391310ac95db"
  revision 1

  bottle do
    cellar :any
    rebuild 2
    sha256 "a65dec30f8f86fdb6cb03d5a225df59dc84d7bf3b4a80001926eba0c888a5d55" => :sierra
    sha256 "4147113f517c79e365dfe0df5f29597937f1be9d7d0477ec22fb3cecd7d0fa3a" => :el_capitan
  end

  devel do
    url "https://savannah.nongnu.org/download/rdiff-backup/rdiff-backup-1.3.3.tar.gz"
    sha256 "ee030ce638df0eb1047cf72578e0de15d9a3ee9ab24da2dc0023e2978be30c06"
  end

  depends_on "librsync"

  # librsync 1.x support
  patch do
    url "https://git.archlinux.org/svntogit/community.git/plain/trunk/rdiff-backup-1.2.8-librsync-1.0.0.patch?h=packages/rdiff-backup"
    mirror "http://pkgs.fedoraproject.org/cgit/rpms/rdiff-backup.git/plain/rdiff-backup-1.2.8-librsync-1.0.0.patch"
    sha256 "a00d993d5ffea32d58a73078fa20c90c1c1c6daa0587690cec0e3da43877bf12"
  end

  def install
    # Find the arch for the Python we are building against.
    # We remove 'ppc' support, so we can pass Intel-optimized CFLAGS.
    archs = archs_for_command("python")
    archs.remove_ppc!
    archs.delete :x86_64 if Hardware::CPU.is_32_bit?
    ENV["ARCHFLAGS"] = archs.as_arch_flags
    system "python", "setup.py", "--librsync-dir=#{prefix}", "build"
    libexec.install Dir["build/lib.macosx*/rdiff_backup"]
    libexec.install Dir["build/scripts-*/*"]
    man1.install Dir["*.1"]
    bin.install_symlink Dir["#{libexec}/rdiff-backup*"]
  end
end
