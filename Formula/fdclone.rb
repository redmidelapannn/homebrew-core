class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://www.unixusers.net/src/fdclone/FD-3.01h.tar.gz"
  sha256 "24be8af52faa48cd6f123d55cfca45d21e5fd1dc16bed24f6686497429f3e2cf"

  bottle do
    rebuild 1
    sha256 "b3cf6b8ad46ba5421c710f9903e01857ede51fc278db4bb21844b5881248561a" => :mojave
    sha256 "b12f44fbd2f677602a1caa343533061f095178a2582cf4c9aedec3eaa1156da5" => :high_sierra
    sha256 "45a6dfe68feff18f10ed5dd74f80fe004978509ad77d600f2791653396ae6527" => :sierra
  end

  depends_on "nkf" => :build
  uses_from_macos "ncurses"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/86107cf/fdclone/3.01b.patch"
    sha256 "c4159db3052d7e4abec57ca719ff37f5acff626654ab4c1b513d7879dcd1eb78"
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "MANTOP=#{man}", "install"

    %w[README FAQ HISTORY LICENSES TECHKNOW ToAdmin].each do |file|
      system "nkf", "-w", "--overwrite", file
      prefix.install "#{file}.eng" => file
      prefix.install file => "#{file}.ja"
    end

    pkgshare.install "_fdrc" => "fd2rc.dist"
  end

  def caveats; <<~EOS
    To install the initial config file:
        install -c -m 0644 #{opt_pkgshare}/fd2rc.dist ~/.fd2rc
    To set application messages to Japanese, edit your .fd2rc:
        MESSAGELANG="ja"
  EOS
  end
end
